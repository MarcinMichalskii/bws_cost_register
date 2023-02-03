import 'package:http/http.dart' as http;

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;

  final http.Client _client = http.Client();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}

class GoogleAuthClient2 extends http.BaseClient {
  final Map<String, String> _headers;
  final int lenth;

  final http.Client _client = http.Client();

  GoogleAuthClient2(this._headers, this.lenth);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    print(request.contentLength.toString());
    request.headers['Content-Length'] = lenth.toString();
    return _client.send(request..headers.addAll(_headers));
  }
}
