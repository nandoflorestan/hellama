const _defaultTimeout = 20000;
const _defaultModel = 'codellama:7b';
const _defaultEndpoint = 'http://localhost:11434';

class Config {
  final String ollamaEndpoint;
  final String ollamaModel;
  final int ollamaTimeout;
  final String? logFile;

  Config({
    required this.ollamaEndpoint,
    required this.ollamaModel,
    required this.ollamaTimeout,
    this.logFile,
  });

  factory Config.fromMap(Map<String, dynamic> map) {
    return Config(
      ollamaEndpoint: map['ollamaEndpoint'] ?? _defaultEndpoint,
      ollamaModel: map['ollamaModel'] ?? _defaultModel,
      ollamaTimeout: map['ollamaTimeout'] ?? _defaultTimeout,
      logFile: map['logFile'],
    );
  }
}
