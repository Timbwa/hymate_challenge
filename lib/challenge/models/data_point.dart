import 'package:equatable/equatable.dart';

class DataPoint extends Equatable {
  const DataPoint({
    required this.name,
    required this.label,
  });

  factory DataPoint.fromMap(Map<String, dynamic> map) {
    return DataPoint(
      name: map['name'] as String,
      label: map['label'] as String,
    );
  }

  final String name;
  final String label;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'label': label,
    };
  }

  @override
  List<Object?> get props => [name, label];
}
