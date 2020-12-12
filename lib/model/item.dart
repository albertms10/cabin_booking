import 'package:uuid/uuid.dart';

abstract class Item {
  String id;
  final DateTime creationDate;
  DateTime modificationDate;
  int modificationCount;

  Item({this.id})
      : creationDate = DateTime.now(),
        modificationCount = 0 {
    id ??= Uuid().v4();
  }

  Item.from(Map<String, dynamic> other)
      : id = other['id'],
        creationDate = DateTime.tryParse(other['creationDate']),
        modificationDate = DateTime.tryParse(other['modificationDate']),
        modificationCount = other['modificationCount'];

  Map<String, dynamic> toMap() => {
        'id': id,
        'creationDate': creationDate.toIso8601String(),
        if (modificationDate != null)
          'modificationDate': modificationDate.toIso8601String(),
        'modificationCount': modificationCount,
      };

  void modify() {
    modificationDate = DateTime.now();
    modificationCount++;
  }
}
