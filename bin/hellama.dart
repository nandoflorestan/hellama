// import 'dart:async';
// import 'dart:convert';
import 'dart:io';

// import 'package:hellama/configuration.dart';
import 'package:hellama/stdin.dart';

// Stream<String> readLine() =>
//     stdin.transform(utf8.decoder).transform(const LineSplitter());
// Stream<String> readStdin() => stdin.transform(utf8.decoder);

/// A server that reads requests from standard input.
class StdioServer {
  String current = "";
  // final Config config;

  // StdioServer(this.config);

  void buildRequest(String text) {
    // print(text);
    current += text;
    print(current);
  }
}

void main() async {
  // var server = StdioServer(config);
  var server = StdioServer();
  List<int> _buffer = []; // Buffer for incoming bytes
  print('hellama LSP server started. Waiting for messages on stdin...');

  // Use a StreamSubscription to handle incoming data chunks
  final stdinSubscription = stdin.listen(
    (List<int> data) {
      // Data might come in chunks, so we need to buffer it
      _buffer.addAll(data);
      // print(Utf8Codec().decode(_buffer));
      processIncomingData(_buffer);
    },
    onDone: () {
      print('Stdin stream closed. Exiting.');
      exit(0);
    },
    onError: (e) {
      print('Error on stdin stream: $e');
      exit(1);
    },
  );
}
