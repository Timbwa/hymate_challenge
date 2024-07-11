import 'package:equatable/equatable.dart';

/// {@template total_power_response_model}
/// Response Model after fetching total power for a given country
/// {@endtemplate}
class PriceResponseModel extends Equatable {
  /// {@macro total_power_response_model}
  const PriceResponseModel({
    required this.licenseInfo,
    required this.unixSeconds,
    required this.price,
    required this.unit,
    required this.deprecated,
  });

  /// Construct [PriceResponseModel] from Map
  factory PriceResponseModel.fromJson(Map<String, Object?> map) {
    final unixSeconds = (map['unix_seconds']! as List<dynamic>).map((value) => value as int).toList();
    final price = (map['price']! as List<dynamic>).map((value) => value as double).toList();

    return PriceResponseModel(
      licenseInfo: map['license_info']! as String,
      unixSeconds: unixSeconds,
      price: price,
      unit: map['unit']! as String,
      deprecated: map['deprecated']! as bool,
    );
  }

  /// The license under which the data from the different bidding zones is published
  final String licenseInfo;

  /// The corresponding time points in which the day ahead spot market price is recorded
  final List<int> unixSeconds;

  /// The market prices over a specified time period
  final List<double> price;

  /// The unit of the market price
  final String unit;

  /// Indicates whether the endpoint returning this response is deprecated
  final bool deprecated;

  @override
  List<Object?> get props => [licenseInfo, unixSeconds, price, unit, deprecated];
}
