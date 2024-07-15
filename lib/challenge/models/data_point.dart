import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hymate_challenge/challenge/challenge.dart';

class DataPoint extends GraphDataPoint with EquatableMixin {
  DataPoint({
    required this.name,
    required this.label,
  });

  factory DataPoint.fromMap(Map<String, dynamic> map) {
    return DataPoint(
      name: map['name'] as String,
      label: map['label'] as String,
    );
  }

  final String name;
  final String label;
  Color? color;

  @override
  List<Object?> get props => [name, label, color];
}
