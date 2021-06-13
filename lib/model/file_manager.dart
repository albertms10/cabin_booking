import 'dart:io' show File;

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
