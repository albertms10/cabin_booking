import 'package:flutter/material.dart';
import 'package:nanoid/nanoid.dart';

import 'serializable.dart';

abstract class _JsonFields {
  static const id = 'id';
  static const creationDateTime = 'cd';
  static const modificationDateTime = 'md';
  static const modificationCount = 'mc';
}

/// An item.
abstract class Item implements Comparable<Item>, Serializable {
  /// The unique identifier of this [Item].
  late String id;

  /// The creation UTC timestamp.
  final DateTime creationDateTime;

  /// The last modification UTC timestamp.
  DateTime? modificationDateTime;

  /// The number of times this [Item] has been modified.
  int modificationCount;

  /// Creates a new [Item].
  Item({String? id})
      : id = id ?? nanoid(),
        creationDateTime = DateTime.now(),
        modificationCount = 0;

  /// Creates a new [Item] from a JSON Map.
  Item.fromJson(Map<String, dynamic> other)
      : id = other[_JsonFields.id] as String,
        creationDateTime =
            DateTime.tryParse(other[_JsonFields.creationDateTime] as String)!,
        modificationDateTime =
            other.containsKey(_JsonFields.modificationDateTime)
                ? DateTime.tryParse(
                    other[_JsonFields.modificationDateTime] as String,
                  )
                : null,
        modificationCount = other[_JsonFields.modificationCount] as int;

  @override
  @mustCallSuper
  Map<String, dynamic> toJson() => {
        _JsonFields.id: id,
        _JsonFields.creationDateTime:
            creationDateTime.toUtc().toIso8601String(),
        if (modificationDateTime != null)
          _JsonFields.modificationDateTime:
              modificationDateTime?.toUtc().toIso8601String(),
        _JsonFields.modificationCount: modificationCount,
      };

  /// Creates a copy of this [Item] but with the given fields replaced with the
  /// new values.
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
  bool operator ==(Object other) => other is Item && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  int compareTo(covariant Item other) => id.compareTo(other.id);
}
