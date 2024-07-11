import 'package:equatable/equatable.dart';

/// {@template total_power_request_model}
/// Request Model containing the parameters when fetching Total Power
/// {@endtemplate}
class TotalPowerRequestModel extends Equatable {
  /// {@macro total_power_request_model}
  const TotalPowerRequestModel({
    this.country = 'de',
    this.start,
    this.end,
  });

  /// The country to get the total net electricity production for.
  /// Currently on supports Germany (de)
  final String country;

  /// The start timezone represented as a UNIX timestamp
  final String? start;

  /// The end timezone represented as a UNIX timestamp
  final String? end;

  @override
  List<Object?> get props => [country, start, end];

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{}..addAll({'country': country});

    if (start != null) {
      result.addAll({'start': start});
    }
    if (end != null) {
      result.addAll({'end': end});
    }

    return result;
  }
}
