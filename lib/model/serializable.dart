import 'package:flutter/material.dart';

abstract class Serializable {
  Serializable.from(Map<String, dynamic> other);

  @mustCallSuper
  Map<String, dynamic> toMap();
}
