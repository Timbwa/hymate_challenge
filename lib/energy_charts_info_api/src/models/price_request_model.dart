import 'package:equatable/equatable.dart';

/// {@template price_request_model}
/// Request Model containing the parameters when fetching the Day Ahead Price
/// {@endtemplate}
class PriceRequestModel extends Equatable {
  /// {@macro price_request_model}
  const PriceRequestModel({
    required this.bzn,
    this.start,
    this.end,
  });

  /// The bidding zone. For a list of available bidding zones refer to
  /// https://api.energy-charts.info/#/prices/day_ahead_price_price_get
  final String bzn;

  /// The start timezone represented as a UNIX timestamp
  final String? start;

  /// The end timezone represented as a UNIX timestamp
  final String? end;

  @override
  List<Object?> get props => [bzn, start, end];

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{}..addAll({'bzn': bzn});
    if (start != null) {
      result.addAll({'start': start});
    }
    if (end != null) {
      result.addAll({'end': end});
    }

    return result;
  }
}
