import 'package:equatable/equatable.dart';
import 'package:hymate_challenge/challenge/models/data_point.dart';

class Category extends Equatable {
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

  @override
  List<Object?> get props => [dataPoints, subcategories];

  @override
  String toString() {
    return 'Category(\n'
        ' label: $label\n'
        ' ${dataPoints.isNotEmpty ? 'data_points' : subcategories.isNotEmpty ? 'categories' : ''} \n'
        ' ${dataPoints.isNotEmpty ? dataPoints : subcategories.isNotEmpty ? subcategories : ''} \n'
        ')';
  }
}
