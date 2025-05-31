Ollama integration for the Helix editor in a simple language server plugin, written in Dart.

Currently focuses on the core functionality of querying Ollama and inserting completions.

To use this language server with Helix, follow these steps:

1. Save the code as `ollama_lsp.dart`
2. Add dependencies to `pubspec.yaml`:
```yaml
dependencies:
  lsp: ^0.7.0
```
3. Install dependencies:
```bash
dart pub get
```

4. Configure Helix (`~/.config/helix/config.toml`):
```toml
[language-server]
ollama-lsp.command = "dart"
ollama-lsp.args = ["path/to/ollama_lsp.dart"]

[keys.normal]
C-g = [":prompt", "ollama.complete"]
```

Key features of this implementation:
- Registers a custom `ollama.complete` command
- Uses the Ollama API with configurable model and parameters
- Maintains document state for context-aware completions
- Applies edits directly to the document
- Uses HttpClient for API communication

To customize the behavior, you can modify:
- `_model`: Default model name ('mistral')
- `_endpoint`: Ollama API endpoint
- `_temperature`: Creativity parameter (0.7)
- `_getContext()`: How much context to send to Ollama

The implementation differs from the original TypeScript version in:
- Single provider (Ollama-only)
- Simplified configuration (hardcoded defaults)
- Non-streaming implementation
- Dart-specific HTTP handling
- LSP package usage instead of direct protocol handling

Note:
1. Requires Dart SDK installed
2. Ollama must be running locally
3. Currently uses default settings (edit code to change model/temperature)
4. Trigger with Ctrl+g in normal mode

This provides a minimal but functional integration with Ollama. For production use, you might want to add:
- Error handling
- Configuration management
- Streaming responses
- Context window limitations
- Multiple cursor support
- Progress notifications
