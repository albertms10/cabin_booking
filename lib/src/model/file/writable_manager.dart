import 'file_manager.dart';

abstract class WritableManager<T> {
  final String fileName;
  late final FileManager fileManager;

  WritableManager(this.fileName) {
    fileManager = FileManager();
  }

  Future<T> readFromFile();

  Future<int> loadFromFile();

  Future<bool> writeToFile();
}
