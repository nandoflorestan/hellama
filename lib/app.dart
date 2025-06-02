import 'dart:io';

// https://pub.dev/packages/logger
import 'package:logger/logger.dart'
    show LogEvent, LogFilter, Logger, SimplePrinter;
// ignore: implementation_imports
import 'package:logger/src/outputs/file_output.dart' show FileOutput;

import 'package:hellama/configuration.dart';

/// Global application object, providing config, logging and other services.
class App {
  final Config config;
  final Logger logger;

  App._ctor(this.config, this.logger);

  factory App(Config config) {
    return App._ctor(config, setUpLogger(config));
  }
}

class NoFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return true;
  }
}

/// Log to file only, since stdout is used for communication with the editor.
Logger setUpLogger(Config config) {
  Logger logger = Logger(
    filter: NoFilter(),
    printer: SimplePrinter(printTime: true, colors: false),
    output: FileOutput(file: File(config.logFile), overrideExisting: false),
  );
  Logger.level = getLoggerLevel(config.logLevel);
  return logger;
}
