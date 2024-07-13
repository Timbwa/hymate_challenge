import 'package:equatable/equatable.dart';
import 'package:hymate_challenge/app/provider/provider.dart';

/// {@template app_state}
/// Holds the current state of the app
/// {@endtemplate}
class AppState extends Equatable {
  /// {@macro app_state}
  const AppState({
    this.lines = const {},
  });

  final Map<String, LineData> lines;

  @override
  List<Object?> get props => [lines];

  /// Returns a new [AppState] object with the passed parameters.
  /// The object will have the same properties as this object if they are not passed.
  AppState copyWith({
    Map<String, LineData>? lines,
  }) {
    return AppState(
      lines: lines ?? this.lines,
    );
  }
}
