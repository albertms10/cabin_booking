import 'package:flutter/material.dart';

abstract class Serializable {
  // ignore: avoid_unused_constructor_parameters
  Serializable.from(Map<String, dynamic> other);

  @mustCallSuper
  Map<String, dynamic> toJson();
}
