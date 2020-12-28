import 'package:uuid/uuid.dart';

abstract class Item {
  String id;
  final DateTime creationDateTime;
  DateTime modificationDateTime;
  int modificationCount;

  Item({this.id})
      : creationDateTime = DateTime.now(),
        modificationCount = 0 {
    id ??= Uuid().v4();
  }

  Item.from(Map<String, dynamic> other)
      : id = other['id'],
        creationDateTime = DateTime.tryParse(other['creationDate']),
        modificationDateTime = other.containsKey('modificationDate')
            ? DateTime.tryParse(other['modificationDate'])
            : null,
        modificationCount = other['modificationCount'];

  Map<String, dynamic> toMap() => {
        'id': id,
        'creationDate': creationDateTime.toIso8601String(),
        if (modificationDateTime != null)
          'modificationDate': modificationDateTime.toIso8601String(),
        'modificationCount': modificationCount,
      };

  void modify() {
    modificationDateTime = DateTime.now();
    modificationCount++;
  }
}
