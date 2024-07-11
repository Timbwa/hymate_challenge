import 'package:equatable/equatable.dart';

/// {@template production_type}
/// The electricity production type for a particular country
/// {@endtemplate}
class ProductionType extends Equatable {
  /// {@macro production_type}
  const ProductionType({
    required this.name,
    required this.data,
  });

  /// Construct [ProductionType] from Map
  factory ProductionType.fromJson(Map<String, Object?> map) {
    final data = (map['data']! as List<dynamic>).map((value) => value as double?).toList();

    return ProductionType(
      name: map['name']! as String,
      data: data,
    );
  }

  /// The name of the production type
  final String name;

  /// The amount of electricity produced over a given time period
  final List<double?> data;

  @override
  List<Object?> get props => [name, data];
}
