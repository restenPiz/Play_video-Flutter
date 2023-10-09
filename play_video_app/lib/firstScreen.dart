import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:video_player/video_player.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen();

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  //!Inicio do metodo responsavel por fazer o fetch dos dados
  List<Map<String, dynamic>> videoUrls = [];

  //* Função para buscar dados da API e atualizar o estado
  Future<void> fetchData() async {

    //Selecionando a url da api
    final response = await http.get(
        Uri.parse('https://raw.githubusercontent.com/bikashthapa01/myvideos-android-app/master/data.json')
    );

    //Inicio do metodo de redirecionamento
    if (response.statusCode == 200) {
      setState(() {
        videoUrls = List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    } else {
      print('Erro na requisição: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData(); // Buscar dados da API quando o widget é inicializado
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video List'),
      ),
      body: ListView.builder(
        itemCount: videoUrls.length,
        itemBuilder: (context, index) {
          VideoPlayerController _controller =
          VideoPlayerController.network(videoUrls[index]);
          _controller.initialize();

          return ListTile(
            title: Text('Video $index'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoPlayerScreen(controller: _controller),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class VideoPlayerScreen extends StatelessWidget {
  final VideoPlayerController controller;

  VideoPlayerScreen({this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: VideoPlayer(controller),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (controller.value.isPlaying) {
            controller.pause();
          } else {
            controller.play();
          }
        },
        child: Icon(
          controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
