// import 'dart:async';
import 'dart:convert';
// import 'dart:io';

import 'package:hellama/app.dart';
import 'package:hellama/entities.dart';

final List<int> headerEnd = [13, 10, 13, 10]; // \r\n\r\n

/// Base class for states of the state machine that processes incoming data.
abstract class StateProcessorBase {
  // Data might come in chunks, so we need to buffer it
  List<int> buffer;
  App app;

  StateProcessorBase(this.app, this.buffer);

  StateProcessorBase? processIncomingData();
}

/// 1st step: Decode headers, especially the Content-Length.
class StateFindingContentLength extends StateProcessorBase {
  StateFindingContentLength(super.app, super.buffer);

  @override
  StateProcessorBase? processIncomingData() {
    // app.logger.w("Buffer: " + utf8.decode(buffer));

    // Try to find the end of the headers (\r\n\r\n)
    final headerEndIndex = _findSequence(buffer, headerEnd); // CR LF CR LF

    if (headerEndIndex == -1) {
      // Not enough data for headers yet, wait for more
      return null;
    }

    // Extract headers
    final headerBytes = buffer.sublist(0, headerEndIndex);
    final headerString = utf8.decode(headerBytes);
    final headers = <String, Header>{};

    for (final line in headerString.split(Header.separator)) {
      final Header? header = Header.fromString(line);
      if (header != null) headers[header.key] = header;
    }
    // app.logger.d("headers: $headers");

    final Header? contentLengthHeader = headers['Content-Length'];
    if (contentLengthHeader == null) {
      // This is a protocol violation. Depending on strictness, you might
      // exit or try to recover (though recovery is hard without content-length).
      throw Exception('Error: Content-Length header missing.');
    }

    final contentLength = int.tryParse(contentLengthHeader.value);
    if (contentLength == null) {
      throw Exception(
        'Error: Invalid Content-Length header: ${contentLengthHeader.value}',
      );
    }
    app.logger.d("Content-Length: $contentLength");

    // Remove processed bytes (headers) from the buffer
    buffer.removeRange(0, headerEndIndex + Header.separator.length + 2);
    // Return the next state to the state machine
    return StateReadingContent(app, buffer, contentLength, headers);
  }
}

/// 2nd step: Get JSON content, decode it, run an LSP method.
class StateReadingContent extends StateProcessorBase {
  final int contentLength;
  final Map<String, Header> headers;

  StateReadingContent(
    super.app,
    super.buffer,
    this.contentLength,
    this.headers,
  );

  @override
  StateProcessorBase? processIncomingData() {
    // Check if we have enough data for the content
    if (buffer.length < contentLength) {
      // Not enough data for the full content, wait for more
      return null;
    }

    // Extract content
    final contentBytes = buffer.sublist(0, contentLength);
    final contentString = utf8.decode(contentBytes);
    app.logger.d('Content: $contentString');

    try {
      RequestMessage msg = RequestMessage(
        RequestContent.fromString(contentString),
      );
      // app.logger.d('Message: $msg');
      // TODO _handleLspMessage(msg);
    } catch (e) {
      app.logger.e(
        'Error decoding JSON content: $e\nContent: "$contentString"',
      );
    }

    // Remove processed bytes from the buffer
    buffer.removeRange(0, contentLength);
    // Return the next state to the state machine
    return StateFindingContentLength(app, buffer);
  }
}

/// State machine that processes incoming data.
class LSPServer {
  App app;
  StateProcessorBase state;

  LSPServer.ctor(this.app, this.state);

  factory LSPServer(App app) {
    return LSPServer.ctor(app, StateFindingContentLength(app, <int>[]));
  }

  void process(List<int> data) {
    // app.logger.t("process(data): ${utf8.decode(data)}");
    state.buffer.addAll(data);
    var newState = state.processIncomingData();
    while (newState != null) {
      state = newState;
      newState = state.processIncomingData();
    }
  }
}

/// Helper to find a byte sequence
int _findSequence(List<int> source, List<int> sequence) {
  if (sequence.isEmpty) return 0;
  if (source.length < sequence.length) return -1;

  for (int i = 0; i <= source.length - sequence.length; i++) {
    bool match = true;
    for (int j = 0; j < sequence.length; j++) {
      if (source[i + j] != sequence[j]) {
        match = false;
        break;
      }
    }
    if (match) {
      return i;
    }
  }
  return -1;
}
