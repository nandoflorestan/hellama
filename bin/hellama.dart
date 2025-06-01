// import 'dart:async';
// import 'dart:convert';
import 'dart:io';

// import 'package:hellama/configuration.dart';
import 'package:hellama/stdin.dart';

void main() async {
  LSPServer server = LSPServer();
  print('hellama LSP server started. Waiting for messages on stdin...');

  // Use a StreamSubscription to handle incoming data chunks
  final stdinSubscription = stdin.listen(
    server.process,
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
