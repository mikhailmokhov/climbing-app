part of 'package:climbing/api/api.dart';

Future<void> uploadFileToSpaces(Uri presignedUrl, File file) async {
  assert(file != null && file.existsSync());
  final http.Response response = await http.put(presignedUrl,
      body: file.readAsBytesSync(),
      headers: <String, String>{'Content-Type': _resolveContentType(file)});
  if (response.statusCode != 200) {
    throw Exception('Request Error: ${response.statusCode}');
  }
}
