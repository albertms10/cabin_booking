import 'package:flutter/material.dart';
import 'package:nanoid/nanoid.dart';

import 'serializable.dart';

abstract class _JsonFields {
  static const id = 'id';
  static const creationDateTime = 'cdt';
  static const modificationDateTime = 'mdt';
  static const modificationCount = 'mc';
}

abstract class Item implements Comparable<Item>, Serializable {
  late String id;
  final DateTime creationDateTime;
  DateTime? modificationDateTime;
  int modificationCount;

  Item({String? id})
      : creationDateTime = DateTime.now().toUtc(),
        modificationCount = 0 {
    this.id = id ?? nanoid();
  }

  Item.from(Map<String, dynamic> other)
      : id = other[_JsonFields.id] as String,
        creationDateTime =
            DateTime.tryParse(other[_JsonFields.creationDateTime] as String)!
                .toUtc(),
        modificationDateTime =
            other.containsKey(_JsonFields.modificationDateTime)
                ? DateTime.tryParse(
                    other[_JsonFields.modificationDateTime] as String,
                  )?.toUtc()
                : null,
        modificationCount = other[_JsonFields.modificationCount] as int;

  @override
  @mustCallSuper
  Map<String, dynamic> toJson() => {
        _JsonFields.id: id,
        _JsonFields.creationDateTime: creationDateTime.toIso8601String(),
        if (modificationDateTime != null)
          _JsonFields.modificationDateTime:
              modificationDateTime?.toIso8601String(),
        _JsonFields.modificationCount: modificationCount,
      };

  Item copyWith();

  void _modify() {
    modificationDateTime = DateTime.now().toUtc();
    modificationCount++;
  }

  @mustCallSuper
  void replaceWith(covariant Item item) {
    _modify();
  }

  @override
  bool operator ==(Object other) => other is Item && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  int compareTo(covariant Item other) => id.compareTo(other.id);
}
