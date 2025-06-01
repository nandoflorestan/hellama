// import 'dart:async';
import 'dart:convert';
// import 'dart:io';

import 'package:hellama/entities.dart';

final List<int> headerEnd = [13, 10, 13, 10]; // \r\n\r\n

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

void processIncomingData(List<int> buffer) {
  while (true) {
    // Try to find the end of the headers (\r\n\r\n)
    final headerEndIndex = _findSequence(buffer, headerEnd); // CR LF CR LF

    if (headerEndIndex == -1) {
      // Not enough data for headers yet, wait for more
      break;
    }

    // Extract headers
    final headerBytes = buffer.sublist(0, headerEndIndex);
    final headerString = utf8.decode(headerBytes);
    final headers = <String, Header>{};

    for (final line in headerString.split(Header.separator)) {
      final Header? header = Header.fromString(line);
      if (header != null) headers[header.key] = header;
    }

    final Header? contentLengthHeader = headers['Content-Length'];
    if (contentLengthHeader == null) {
      print('Error: Content-Length header missing.');
      // This is a protocol violation. Depending on strictness, you might
      // exit or try to recover (though recovery is hard without content-length).
      throw Exception("Can't proceed without knowing content length!");
    }

    final contentLength = int.tryParse(contentLengthHeader.value);
    if (contentLength == null) {
      throw Exception(
        'Error: Invalid Content-Length header: ${contentLengthHeader.value}',
      );
    }

    // TODO split the function here!
    // Calculate start of content in buffer
    final contentStartIndex = headerEndIndex + Header.separator.length;

    // Check if we have enough data for the content
    if (buffer.length < contentStartIndex + contentLength) {
      // Not enough data for the full content, wait for more
      break;
    }

    // Extract content
    final contentBytes = buffer.sublist(
      contentStartIndex,
      contentStartIndex + contentLength,
    );
    final contentString = utf8.decode(contentBytes);

    try {
      RequestMessage msg = RequestMessage.fromString(contentString);
      print(msg);
      // TODO _handleLspMessage(msg);
    } catch (e) {
      print('Error decoding JSON content: $e\nContent: "$contentString"');
    }

    // Remove processed bytes from the buffer
    buffer.removeRange(0, contentStartIndex + contentLength);
  }
}
