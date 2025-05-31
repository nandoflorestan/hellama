import 'package:hellama/entities.dart';
// import 'package:lsp_server/lsp_server.dart';
// import 'package:hellama/hellama.dart';
import 'package:test/test.dart';

void main() {
  var params = {"key": "value"};
  RequestMessage aMessage = RequestMessage(
    RequestContent("myMethod", params, 1),
  );
  String aText =
      'Content-Length: 69\r\n'
      '\r\n'
      '{"jsonrpc":"2.0","id":1,"method":"myMethod","params":{"key":"value"}}';

  test("test message encoding", () {
    String aMsgStr = aMessage.toString();
    expect(aText, aMsgStr);
  });

  test("test message decoding", () {
    RequestMessage built = RequestMessage.fromString(aText);
    expect(built.content.id, aMessage.content.id);
    expect(built.content.method, aMessage.content.method);
    expect(built.content.params, aMessage.content.params);
  });
}
