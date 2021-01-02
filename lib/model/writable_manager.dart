import 'package:cabin_booking/model/file_manager.dart';

abstract class WritableManager<T> {
  final String fileName;
  FileManager fileManager;

  WritableManager(this.fileName) {
    fileManager = FileManager();
  }

  Future<T> readFromFile();

  Future loadFromFile();

  Future<bool> writeToFile();
}
