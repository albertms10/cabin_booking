import 'package:cabin_booking/model/file_manager.dart';

abstract class WritableManager<T> with FileManager {
  final String fileName;

  const WritableManager(this.fileName);

  Future<T> readFromFile();

  Future loadFromFile();

  Future<bool> writeToFile();
}
