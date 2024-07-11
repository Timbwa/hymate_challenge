/// Exposes extension on [DateTime]
extension DateTimeExtension on DateTime {
  /// Get [DateTime] as a UNIX Timestamp as the number of seconds since the UNIX epoch
  int get unixTimeStampInSeconds {
    final unixTimestampMillis = millisecondsSinceEpoch;
    final unixTimestampSeconds = unixTimestampMillis ~/ 1000;

    return unixTimestampSeconds;
  }
}
