import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

abstract class Item implements Comparable<Item> {
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
      : id = other['id'] as String,
        creationDateTime = DateTime.tryParse(other['creationDate'] as String),
        modificationDateTime = other.containsKey('modificationDate')
            ? DateTime.tryParse(other['modificationDate'] as String)
            : null,
        modificationCount = other['modificationCount'] as int;

  @mustCallSuper
  Map<String, dynamic> toMap() => {
        'id': id,
        'creationDate': creationDateTime.toIso8601String(),
        if (modificationDateTime != null)
          'modificationDate': modificationDateTime.toIso8601String(),
        'modificationCount': modificationCount,
      };

  Item copyWith();

  void _modify() {
    modificationDateTime = DateTime.now();
    modificationCount++;
  }

  @mustCallSuper
  void replaceWith(covariant Item item) {
    _modify();
  }

  @override
  bool operator ==(other) => other is Item && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  int compareTo(covariant Item other) => id.compareTo(other.id);
}
