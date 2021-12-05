import 'dart:convert';
import 'dart:io' show File, gzip;

import 'package:path_provider/path_provider.dart';

class FileManager {
  static final FileManager _fileManager = FileManager._internal();

  factory FileManager() => _fileManager;

  FileManager._internal();

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> localFile(String fileName) async {
    final path = await _localPath;

    return File('$path/$fileName.json');
  }
}

extension FileExtension on File {
  Future<File> writeAsCompressedString(String contents) => writeAsString(
        String.fromCharCodes(gzip.encode(utf8.encode(contents))),
      );

  Future<String> readAsUncompressedString() async =>
      utf8.decode(gzip.decode((await readAsString()).codeUnits));
}
