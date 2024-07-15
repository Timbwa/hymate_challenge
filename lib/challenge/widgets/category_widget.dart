import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hymate_challenge/challenge/models/models.dart';
import 'package:quiver/iterables.dart';

class CategoryWidget extends StatefulWidget {
  const CategoryWidget({
    required this.category,
    required this.selectedCategories,
    required this.selectedDataPoints,
    required this.onCategorySelectionChanged,
    required this.onDataPointSelectionChanged,
    this.availableColors = const [],
    super.key,
  });

  final Category category;
  final List<Color> availableColors;
  final List<Category> selectedCategories;
  final List<DataPoint> selectedDataPoints;
  final void Function(List<Category> selectedCategories) onCategorySelectionChanged;
  final void Function(List<DataPoint> selectedDatapoints) onDataPointSelectionChanged;

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  bool _isExpanded = true;
  final _random = Random();
  late Color _categoryColor;
  final List<Color> _dataPointColors = [];

  @override
  void initState() {
    super.initState();
    final categoryColorIndex = _random.nextInt(widget.availableColors.length);
    _categoryColor = widget.availableColors[categoryColorIndex];

    widget.category.color = _categoryColor;

    for (final _ in widget.category.dataPoints) {
      _dataPointColors.add(widget.availableColors[_random.nextInt(widget.availableColors.length)]);
    }
  }

  void _toggleCategorySelection(Category category) {
    setState(() {
      if (widget.selectedCategories.contains(category)) {
        widget.selectedCategories.remove(category);
      } else {
        widget.selectedCategories.add(category);
      }
      widget.onCategorySelectionChanged(widget.selectedCategories);
    });
  }

  void _toggleDataPointSelection(DataPoint datapoint) {
    setState(() {
      if (widget.selectedDataPoints.contains(datapoint)) {
        widget.selectedDataPoints.remove(datapoint);
      } else {
        widget.selectedDataPoints.add(datapoint);
      }
      widget.onDataPointSelectionChanged(widget.selectedDataPoints);
    });
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  bool _isDataPointSelected(DataPoint dataPoint) {
    return widget.selectedDataPoints.contains(dataPoint);
  }

  @override
  Widget build(BuildContext context) {
    final category = widget.category;
    final isCategorySelected = widget.selectedCategories.contains(category);
    final doesCategoryHaveChildren = category.subcategories.isNotEmpty || category.dataPoints.isNotEmpty;
    const listTileIconAndTextColor = Colors.white70;
    final textStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(color: listTileIconAndTextColor);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: InkWell(
            onTap: () => _toggleCategorySelection(category),
            child: Icon(
              isCategorySelected ? Icons.circle : Icons.circle_outlined,
              color: isCategorySelected ? _categoryColor : listTileIconAndTextColor,
              size: 16,
            ),
          ),
          title: Text(category.label, style: textStyle),
          trailing: doesCategoryHaveChildren
              ? IconButton(
                  onPressed: _toggleExpansion,
                  icon: Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: listTileIconAndTextColor,
                  ),
                )
              : null,
        ),
        if (_isExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...category.subcategories.map(
                  (subCategory) {
                    return CategoryWidget(
                      category: subCategory,
                      availableColors: widget.availableColors,
                      selectedCategories: widget.selectedCategories,
                      selectedDataPoints: widget.selectedDataPoints,
                      onCategorySelectionChanged: widget.onCategorySelectionChanged,
                      onDataPointSelectionChanged: widget.onDataPointSelectionChanged,
                    );
                  },
                ),
                ...enumerate(category.dataPoints).map(
                  (dataPoint) {
                    final dataPointColor = _dataPointColors[dataPoint.index];
                    dataPoint.value.color = dataPointColor;

                    return ListTile(
                      leading: InkWell(
                        onTap: () => _toggleDataPointSelection(dataPoint.value),
                        child: Icon(
                          size: 16,
                          _isDataPointSelected(dataPoint.value) ? Icons.circle : Icons.circle_outlined,
                          color: _isDataPointSelected(dataPoint.value) ? dataPointColor : listTileIconAndTextColor,
                        ),
                      ),
                      title: Text(
                        dataPoint.value.label,
                        style: textStyle,
                      ),
                    );
                  },
                )
              ],
            ),
          ),
      ],
    );
  }
}
