import 'package:equatable/equatable.dart';
import 'package:hymate_challenge/energy_charts_info_api/src/models/models.dart';

/// {@template total_power_response_model}
/// Response Model after fetching total power for a given country
/// {@endtemplate}
class TotalPowerResponseModel extends Equatable {
  /// {@macro total_power_response_model}
  const TotalPowerResponseModel({
    required this.unixSeconds,
    required this.productionTypes,
    required this.deprecated,
  });

  /// Construct [TotalPowerResponseModel] from Map
  factory TotalPowerResponseModel.fromJson(Map<String, dynamic> map) {
    final unixSeconds = (map['unix_seconds']! as List<dynamic>).map((value) => value as int).toList();
    final productionTypes = (map['production_types']! as List<dynamic>)
        .map((value) => ProductionType.fromJson(value as Map<String, dynamic>))
        .toList();

    return TotalPowerResponseModel(
      unixSeconds: unixSeconds,
      productionTypes: productionTypes,
      deprecated: map['deprecated'] as bool,
    );
  }

  /// The corresponding time points in which electricity production was recorded for the [productionTypes]
  final List<int> unixSeconds;

  /// The different electricity production types for a given time period
  final List<ProductionType> productionTypes;

  /// Indicates whether the endpoint returning this response is deprecated
  final bool deprecated;

  @override
  List<Object?> get props => [unixSeconds, productionTypes, deprecated];
}
