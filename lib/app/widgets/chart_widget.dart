import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hymate_challenge/app/provider/provider.dart';
import 'package:hymate_challenge/theme/theme.dart';
import 'package:quiver/iterables.dart';

class ChartWidget extends ConsumerWidget {
  ChartWidget({
    super.key,
  });

  static const int _minTimeHour = 0;
  static const int _maxTimeHour = 24;
  final List<List<FlSpot>> _flSpots = [];
  static const TextStyle _titleTextStyle = TextStyle(color: AppColors.seedColor);

  Widget _bottomTitlesWidget(double xValue, TitleMeta meta) {
    final text = xValue.toInt() == _minTimeHour || xValue.toInt() == _maxTimeHour ? '' : '${xValue.toInt()}:00';

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 6,
      fitInside: SideTitleFitInsideData.fromTitleMeta(meta, distanceFromEdge: 4),
      child: Text(text, style: _titleTextStyle),
    );
  }

  FlTitlesData _titlesData() {
    return FlTitlesData(
      topTitles: const AxisTitles(),
      rightTitles: const AxisTitles(),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          interval: 50,
          getTitlesWidget: (yValue, meta) {
            return yValue != meta.max ? Text(meta.formattedValue, style: _titleTextStyle) : const Text('');
          },
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          interval: 6,
          getTitlesWidget: _bottomTitlesWidget,
        ),
      ),
    );
  }

  FlLine _getHorizontalVerticalLine(double value) {
    if ((value - 0).abs() <= 0.1) {
      return const FlLine(
        color: Colors.white70,
        strokeWidth: 1,
        dashArray: [8, 4],
      );
    } else {
      return _getDefaultGraphLine(value);
    }
  }

  FlLine _getDefaultGraphLine(double value) {
    return const FlLine(
      color: AppColors.graphGridLineColor,
      strokeWidth: 0.4,
      dashArray: [8, 4],
    );
  }

  /// Normalize [value] from it's domain ([inputMin], [inputMax]) - inclusive
  /// to a target domain ([targetMin], [targetMax])
  double normalize(double value, double inputMin, double inputMax, double targetMin, double targetMax) {
    assert(inputMin != inputMax, "The input maximum and minimum can't be the same. Potential division by zero!");

    // Normalize to [0, 1]
    final normalized = (value - inputMin) / (inputMax - inputMin);

    // scale and shift normalized value to target range
    return targetMin + normalized * (targetMax - targetMin);
  }

  void normalizeFlSpotTimeStamps() {
    final minTimeStamp = min(_flSpots.expand((spots) => spots).toList(), (a, b) => a.x.compareTo(b.x))!.x;
    final maxTimeStamp = max(_flSpots.expand((spots) => spots).toList(), (a, b) => a.x.compareTo(b.x))!.x;

    for (final flSpotList in _flSpots) {
      for (final flSpotIndexedValue in enumerate(flSpotList)) {
        final index = flSpotIndexedValue.index;
        final flSpot = flSpotIndexedValue.value;
        flSpotList[index] = flSpot.copyWith(
          x: normalize(flSpot.x, minTimeStamp, maxTimeStamp, 0, 24),
        );
      }
    }
  }

  void convertMapOfLineDataToListOfFlSpots(Map<String, LineData> lines) {
    _flSpots.clear();
    for (final line in lines.values) {
      final flSpots = zip([line.unixTimestamps, line.yDataPoints])
          .map((value) => FlSpot(value[0]?.toDouble() ?? 0, value[1]?.toDouble() ?? 0))
          .toList();
      _flSpots.add(flSpots);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(appStateNotifierProvider).maybeWhen(
          orElse: () {},
          data: (appState) {
            convertMapOfLineDataToListOfFlSpots(appState.lines);
            normalizeFlSpotTimeStamps();
          },
        );

    // increase the maximum and minimum values of LineChart Data to give allowance for the graph
    var minY = min(_flSpots.expand((spots) => spots).toList(), (a, b) => a.y.compareTo(b.y))?.y;
    var maxY = max(_flSpots.expand((spots) => spots).toList(), (a, b) => a.y.compareTo(b.y))?.y;
    minY = minY != null && minY > 0 ? 0 : (minY != null ? minY - 10.0 : 0).floorToDouble();
    maxY = maxY != null ? (maxY + 20).ceilToDouble() : maxY;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.graphBackgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: LineChart(
              LineChartData(
                minY: minY,
                maxY: maxY,
                titlesData: _titlesData(),
                backgroundColor: AppColors.graphBackgroundColor,
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  horizontalInterval: 20,
                  verticalInterval: 6,
                  getDrawingVerticalLine: _getDefaultGraphLine,
                  getDrawingHorizontalLine: _getHorizontalVerticalLine,
                ),
                lineBarsData: [
                  for (final indexedItem in enumerate(_flSpots))
                    LineChartBarData(
                      spots: indexedItem.value,
                      color: AppColors.lineGraphColors[indexedItem.index],
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          // start from bottom to top because of the list generation of colors with increasing index
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: List.generate(
                            6,
                            (index) => AppColors.lineGraphColors[indexedItem.index].withOpacity(index / 10),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
