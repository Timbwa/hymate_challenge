import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hymate_challenge/challenge/challenge.dart';
import 'package:hymate_challenge/theme/theme.dart';

class Challenge extends StatefulWidget {
  const Challenge({super.key});

  @override
  State<Challenge> createState() => _ChallengeState();
}

class _ChallengeState extends State<Challenge> {
  final random = Random(777);

  final List<Category> _categories = [];
  List<Category> _selectedCategories = [];
  List<DataPoint> _selectedDataPoints = [];
  late List<Color> _categoryAndDatapointColors;

  List<Color> _generateRandomColors(int length) {
    Color generateColor() {
      final red = 128 + random.nextInt(128);
      final green = 128 + random.nextInt(128);
      final blue = 128 + random.nextInt(128);

      return Color.fromARGB(255, red, green, blue);
    }

    return List.generate(length, (index) => generateColor());
  }

  /// Randomly generates a colors list for Categories and DataPoints with length = no of categories + no of dataPoints
  void _updateCategoryAndDataPointColors() {
    setState(() {
      _categoryAndDatapointColors = _generateRandomColors(
        _categories.fold(0, (sum, category) => sum + category.length(initialSum: 1)),
      );
    });
  }

  Future<void> _parseDataPointsJson() async {
    await rootBundle.loadString('assets/data_points.json').then((dataPointsJsonString) {
      final categoriesJson = jsonDecode(dataPointsJsonString) as Map<String, dynamic>;
      final categories = (categoriesJson['categories'] as List<dynamic>)
          .map((value) => Category.fromMap(value as Map<String, dynamic>))
          .toList();

      setState(() {
        _selectedCategories.clear();
        _selectedDataPoints.clear();

        _categories
          ..clear()
          ..addAll(categories);
      });
    });
  }

  Plot _createPlot({
    required int id,
    required String name,
    required List<Category> selectedCategories,
    required List<DataPoint> selectedDataPoints,
  }) {
    final primaryYAxisGraphs = <Graph>[];

    // Create Graphs for each selected Category
    for (final category in selectedCategories) {
      primaryYAxisGraphs.add(
        Graph(
          id: primaryYAxisGraphs.length,
          name: category.label,
          dataPoints: [category],
        ),
      );
    }

    // Create a Graph for selected DataPoints
    if (selectedDataPoints.isNotEmpty) {
      primaryYAxisGraphs.add(Graph(
        id: primaryYAxisGraphs.length,
        name: 'Selected DataPoints',
        dataPoints: selectedDataPoints,
      ));
    }

    return Plot(
      id: id,
      name: name,
      primaryYAxisGraphs: primaryYAxisGraphs,
    );
  }

  void _createPlotAndPrintToConsole() {
    final plot = _createPlot(
      id: 0,
      name: 'Sample Plot',
      selectedCategories: _selectedCategories,
      selectedDataPoints: _selectedDataPoints,
    );

    print(plot.prettyJson());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Challenge'),
      ),
      body: Center(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: AppColors.graphBackgroundColor,
          ),
          child: ListView(
            children: [
              ..._categories.map(
                (category) {
                  return CategoryWidget(
                    category: category,
                    selectedCategories: _selectedCategories,
                    selectedDataPoints: _selectedDataPoints,
                    availableColors: _categoryAndDatapointColors,
                    onCategorySelectionChanged: (selectedCategories) {
                      setState(() {
                        _selectedCategories = [...selectedCategories];
                      });
                      _createPlotAndPrintToConsole();
                    },
                    onDataPointSelectionChanged: (selectedDataPoints) {
                      setState(() {
                        _selectedDataPoints = [...selectedDataPoints];
                      });
                      _createPlotAndPrintToConsole();
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await _parseDataPointsJson().then((_) {
                        _updateCategoryAndDataPointColors();
                      });
                    },
                    child: const Text('Parse json and create hierarchy'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: _createPlotAndPrintToConsole,
                    child: const Text('Print selection'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
