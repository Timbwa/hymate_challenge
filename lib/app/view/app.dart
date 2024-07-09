import 'package:flutter/material.dart';

// ignore_for_file: public_member_api_docs
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Yes World!'),
        ),
      ),
    );
  }
}
