import 'package:equatable/equatable.dart';

class LineData extends Equatable {
  const LineData({
    required this.name,
    required this.unixTimestamps,
    required this.yDataPoints,
  });

  final String name;
  final List<int> unixTimestamps;
  final List<double?> yDataPoints;

  @override
  List<Object?> get props => [name, unixTimestamps, yDataPoints];
}
