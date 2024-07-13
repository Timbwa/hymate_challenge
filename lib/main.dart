import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hymate_challenge/app/app.dart';
import 'package:hymate_challenge/logging/provider_logger.dart';

void main() {
  runApp(
    ProviderScope(
      observers: [ProviderLogger()],
      child: const App(),
    ),
  );
}
