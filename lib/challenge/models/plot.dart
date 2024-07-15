import 'dart:convert';

import 'package:hymate_challenge/challenge/models/models.dart';

class Plot {
  Plot({
    required this.id,
    required this.name,
    required this.primaryYAxisGraphs,
    this.xAxisDataSeries,
  });

  int id;
  String name;
  List<dynamic>? xAxisDataSeries;
  late List<Graph> primaryYAxisGraphs;

  Map<String, dynamic> toMap() {
    return {
      'id': id.toString(),
      'data': {
        'datapoints': primaryYAxisGraphs
            .expand((graph) => graph.dataPoints)
            .whereType<DataPoint>()
            .map((dataPoint) => dataPoint.name)
            .toList(),
        'extra': primaryYAxisGraphs
            .expand((graph) => graph.dataPoints)
            .whereType<Category>()
            .map(
              (category) => {
                'operation': 'sum',
                'datapoints': category.getAllChildDataPoints().map((dataPoint) => dataPoint.name).toList(),
                'label': category.label,
              },
            )
            .toList(),
      },
      'label': name,
    };
  }

  String toJson() => jsonEncode(toMap());

  /// indents and adds new lines to Json String
  String prettyJson() {
    const encoder = JsonEncoder.withIndent(' ');
    return encoder.convert(toMap());
  }
}
