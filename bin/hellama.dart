// import 'dart:async';
// import 'dart:convert';
import 'dart:io';

// import 'package:hellama/configuration.dart';
import 'package:hellama/app.dart';
import 'package:hellama/configuration.dart';
import 'package:hellama/stdin.dart';

void main() async {
  Config config = Config.fromMap({}); // TODO Read configuration from file
  App app = App(config);
  LSPServer server = LSPServer(app);
  app.logger.i('hellama LSP server started. Waiting for messages on stdin...');

  // Use a StreamSubscription to handle incoming data chunks
  final stdinSubscription = stdin.listen(
    server.process,
    onDone: () {
      app.logger.i('Stdin stream closed. Exiting.');
      exit(0);
    },
    onError: (e) {
      app.logger.i('Error on stdin stream: $e');
      exit(1);
    },
  );
}
