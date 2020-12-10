import 'package:uuid/uuid.dart';

abstract class Item {
  String id;
  final DateTime creationDate;
  DateTime modificationDate;
  int modificationCount;

  Item({id})
      : creationDate = DateTime.now(),
        modificationCount = 0 {
    id ??= Uuid().v4();
  }

  void modify() {
    modificationDate = DateTime.now();
    modificationCount++;
  }
}
