import 'package:flutter/material.dart';

class firstScreen extends StatefulWidget {
  const firstScreen({super.key});

  @override
  State<firstScreen> createState() => _State();
}

class _State extends State<firstScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Inicio do appBar
      appBar: AppBar(
        title: Text('Video Application'),
      ),
      //Inicio do container
      body: Container(
        child: Column(
          children: [
            Text('Ola Mundo'),
          ],
        ),
      ),
    );
  }
}
