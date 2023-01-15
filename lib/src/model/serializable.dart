import 'package:flutter/material.dart';

/// Contract with the required methods to JSON-serialize an object.
mixin Serializable {
  /// Returns a serialized JSON representation of this object instance.
  @mustCallSuper
  Map<String, dynamic> toJson();
}

/// Contract with the required methods to JSON-serialize an array of objects.
mixin SerializableList {
  /// Returns a serialized JSON representation of this object array instance.
  @mustCallSuper
  List<Map<String, dynamic>> toJson();
}
