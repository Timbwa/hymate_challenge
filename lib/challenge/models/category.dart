import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hymate_challenge/challenge/challenge.dart';

/// {@template category}
/// Category with recursive [subcategories]
/// Should not have both [subcategories] and [dataPoints] as leaves. i.e they exist in the object exclusively
/// {@endtemplate}
class Category extends GraphDataPoint with EquatableMixin {
  /// {@macro category}
  Category({
    required this.label,
    this.dataPoints = const [],
    this.subcategories = const [],
  }) : assert(
          !(dataPoints.isNotEmpty && subcategories.isNotEmpty),
          'Neither dataPoints nor subcategories should have elements at the same time',
        );

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      label: map['label'] as String,
      // recursively construct subcategories
      subcategories: map['subcategories'] != null
          ? (map['subcategories'] as List<dynamic>)
              .map((categoryMap) => Category.fromMap(categoryMap as Map<String, dynamic>))
              .toList()
          : const [],
      dataPoints: map['data_points'] != null
          ? (map['data_points'] as List<dynamic>)
              .map((dataPointMap) => DataPoint.fromMap(dataPointMap as Map<String, dynamic>))
              .toList()
          : const [],
    );
  }

  final String label;
  final List<DataPoint> dataPoints;
  final List<Category> subcategories;
  Color? color;

  /// Returns the total number of [subcategories] and [dataPoints]
  /// Can modify [initialSum] to 1 to not count the current object
  int length({int initialSum = 0}) {
    if (dataPoints.isNotEmpty) {
      return dataPoints.length;
    }

    var currentSum = initialSum + 1;

    for (final category in subcategories) {
      currentSum += category.length(initialSum: currentSum);
    }

    return currentSum;
  }

  List<DataPoint> getAllChildDataPoints() {
    if (dataPoints.isNotEmpty) {
      return dataPoints;
    }

    final currentDataPoints = <DataPoint>[];

    for (final category in subcategories) {
      currentDataPoints.addAll(category.getAllChildDataPoints());
    }

    return currentDataPoints;
  }

  @override
  List<Object?> get props => [label, dataPoints, subcategories, color];

  @override
  String toString() {
    return 'Category(\n'
        ' label: $label\n'
        ' ${dataPoints.isNotEmpty ? 'data_points' : subcategories.isNotEmpty ? 'categories' : ''} \n'
        ' ${dataPoints.isNotEmpty ? dataPoints : subcategories.isNotEmpty ? subcategories : ''} \n'
        ')';
  }
}
