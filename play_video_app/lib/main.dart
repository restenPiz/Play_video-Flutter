import 'package:flutter/material.dart';

import 'firstScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //Instanciando a minha widget responsavel por fazer o show de todos os dados
      home: firstScreen(),
    );
  }

}
