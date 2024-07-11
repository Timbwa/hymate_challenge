import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Extension to cancel pending requests for example a user exits a page
/// while a request is still pending.
extension CancelTokenX on Ref {
  /// Gets a cancel token that cancels a request when a provider is disposed
  CancelToken cancelToken() {
    final cancelToken = CancelToken();
    onDispose(cancelToken.cancel);
    return cancelToken;
  }
}
