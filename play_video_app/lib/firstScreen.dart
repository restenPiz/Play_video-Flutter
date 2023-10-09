import 'package:flutter/material.dart';

class firstScreen extends StatefulWidget {
  const firstScreen({super.key});

  @override
  State<firstScreen> createState() => _State();
}

class _State extends State<firstScreen> {
  @override

  //Inicio do metodo responsavel por fazer o get de todos os dados da API
  void fetchData() async {
    final response = await http.get(
        'https://raw.githubusercontent.com/bikashthapa01/myvideos-android-app/master/data.json');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        videoUrls = List<String>.from(data['videos']);
      });
    }
  }

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
