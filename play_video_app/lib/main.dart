import 'package:flutter/material.dart';
import 'firstScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirstScreen(), // Use FirstScreen() em vez de firstScreen()
    );
  }
}
