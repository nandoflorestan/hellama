Toy project. Pre-alpha quality.
This is a work in progress, it does not do anything useful yet.
Just a personal project to learn the Dart language and libraries.
But in the future:

**Ollama integration for the Helix editor in a simple language server plugin, written in Dart.**

Currently focuses on the core functionality of querying Ollama and inserting completions.

To use this language server with Helix, follow these steps:

1. Compile with `dart compile exe bin/hellama.dart`
2. Configure Helix (`~/.config/helix/config.toml`):

```toml
[language-server]
ollama-lsp.command = "path/to/bin/hellama.exe"
ollama-lsp.args = []

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

Limitations:

- Single provider (Ollama-only)
- Simplified configuration (hardcoded defaults)
- Non-streaming implementation
- Dart-specific HTTP handling
- LSP package usage instead of direct protocol handling

Note:

1. Requires Dart SDK installed, to compile.
2. Ollama must be running locally.
3. Currently uses default settings (edit code to change model/temperature).
4. Trigger with Ctrl+g in normal mode.

This provides a minimal but functional integration with Ollama.
For production use, we might want to add:

- Error handling
- Configuration management
- Streaming responses
- Context window limitations
- Multiple cursor support
- Progress notifications
