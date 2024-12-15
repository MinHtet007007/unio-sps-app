import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

Future<String> getFilePath(Uint8List content) async {
  final dir = await getTemporaryDirectory(); // Get the temp directory
  File file = await File('${dir.path}/${uniqueFilename('png')}').create();
  file.writeAsBytesSync(content);
  return file.path;
}

String uniqueFilename(String ext) {
  var now = DateTime.now();
  var random = (10000000 + Random().nextInt(90000000)).toString();
  return "${now.year}${now.month}${now.day}${now.hour}${now.minute}${now.second}_$random.$ext";
}
Future<File> createDummyFile(String fileName, String content) async {
  final directory = await getTemporaryDirectory(); // Get the temp directory
  final file = File('${directory.path}/$fileName');
  return file.writeAsString(content); // Write some dummy content
}
