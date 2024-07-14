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

  Future<void> _parseDataPointsJson() async {
    await rootBundle.loadString('assets/data_points.json').then((dataPointsJsonString) {
      final categoriesJson = jsonDecode(dataPointsJsonString) as Map<String, dynamic>;
      final categories = (categoriesJson['categories'] as List<dynamic>)
          .map((value) => Category.fromMap(value as Map<String, dynamic>))
          .toList();

      setState(() {
        _categories
          ..clear()
          ..addAll(categories);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Challenge'),
      ),
      body: Center(
        child: Container(
          color: AppColors.graphBackgroundColor,
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
                    },
                    onDataPointSelectionChanged: (selectedDataPoints) {
                      setState(() {
                        _selectedDataPoints = [...selectedDataPoints];
                      });
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
                        setState(() {
                          _categoryAndDatapointColors = _generateRandomColors(
                            _categories.fold(0, (sum, category) => sum + category.length(initialSum: 1)),
                          );
                        });
                      });
                    },
                    child: const Text('Parse json and create hierarchy'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Implement mapping to plot and graph objects
                    },
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
