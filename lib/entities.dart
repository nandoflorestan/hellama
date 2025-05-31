import 'dart:convert';

/// A header in an LSP message.
///
/// https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#headerPart
class Header {
  final String key;
  final String value;

  Header(this.key, this.value);

  @override
  String toString() {
    return '$key: $value$separator';
  }

  static String separator = '\r\n';
}

/// The content of a request between client and server.
///
/// https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#requestMessage
class RequestContent {
  final int id;
  final String method;
  final Map params;

  RequestContent(this.method, this.params, this.id);

  toMap() {
    return {"jsonrpc": "2.0", "id": id, "method": method, "params": params};
  }

  @override
  String toString() {
    return jsonEncode(toMap());
  }

  static RequestContent fromString(String text) {
    Map amap = jsonDecode(text);
    return RequestContent(amap["method"], amap["params"], amap["id"]);
  }
}

/// A request message between client and server.
///
/// Generates the Content-Length header automatically.
///
/// https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#baseProtocol
class RequestMessage {
  final RequestContent content;

  RequestMessage(this.content);

  @override
  String toString() {
    final contentStr = content.toString();
    final header = Header("Content-Length", contentStr.length.toString());
    return "$header${Header.separator}$contentStr";
  }

  static RequestMessage fromString(String text) {
    // TODO Validate the Content-Length header
    // TODO Support the Content-Type header, which contains charset
    String sep = Header.separator * 2;
    var parts = text.split(sep);
    int lenHeaders = parts[0].length + sep.length;
    String content = text.substring(lenHeaders);
    return RequestMessage(RequestContent.fromString(content));
  }
}
