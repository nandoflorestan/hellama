import 'package:logger/logger.dart';

const _defaultTimeout = 20000;
const _defaultModel = 'codellama:7b';
const _defaultEndpoint = 'http://localhost:11434';

class Config {
  final String ollamaEndpoint;
  final String ollamaModel;
  final int ollamaTimeout;
  final String logFile;
  final String logLevel;

  Config({
    required this.ollamaEndpoint,
    required this.ollamaModel,
    required this.ollamaTimeout,
    required this.logFile,
    required this.logLevel,
  });

  factory Config.fromMap(Map<String, dynamic> map) {
    return Config(
      ollamaEndpoint: map['ollamaEndpoint'] ?? _defaultEndpoint,
      ollamaModel: map['ollamaModel'] ?? _defaultModel,
      ollamaTimeout: map['ollamaTimeout'] ?? _defaultTimeout,
      logFile: map['logFile'] ?? "/tmp/hellama.log",
      logLevel: map['logLevel'] ?? "all", // TODO should be warning:
      // logLevel: map['logLevel'] ?? "warning",
    );
  }
}

/// Translate config text into an enum value for logger level.
Level getLoggerLevel(String text) {
  switch (text.toLowerCase()) {
    case "all":
      return Level.all;
    case "trace":
      return Level.trace;
    case "debug":
      return Level.debug;
    case "info":
      return Level.info;
    case "warning":
      return Level.warning;
    case "error":
      return Level.error;
    case "fatal":
      return Level.fatal;
    case "off":
      return Level.off;
    default:
      return Level.all; // TODO should be warning:
    // return Level.warning;
  }
}
