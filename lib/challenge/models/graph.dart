import 'package:flutter/material.dart';
import 'package:hymate_challenge/challenge/models/models.dart';

class Graph {
  Graph({
    required this.id,
    required this.name,
    required this.dataPoints,
    this.availableXData,
    this.color,
    this.values,
  });

  int id;
  String name;

  List<GraphDataPoint> dataPoints;
  List<dynamic>? availableXData;
  Color? color;
  List<double?>? values;
}
