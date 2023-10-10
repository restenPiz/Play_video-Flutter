import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirstScreen(),
    );
  }
}

class FirstScreen extends StatefulWidget {
  const FirstScreen();

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  List<Map<String, dynamic>> videoData = [];

  Future<void> fetchData() async {
    final response = await http.get(
        Uri.parse('https://raw.githubusercontent.com/bikashthapa01/myvideos-android-app/master/data.json'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.containsKey('categories') && data['categories'] is List<dynamic>) {
        setState(() {
          videoData = List<Map<String, dynamic>>.from(data['categories'][0]['videos']);
        });
      } else {
        print('Chave "videos" não encontrada ou não é uma lista válida.');
      }
    } else {
      print('Erro na requisição: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resten - Midia'),
      ),
      body: ListView.builder(
        itemCount: videoData.length,
        itemBuilder: (context, index) {
          return VideoListItem(videoData[index]);
        },
      ),
    );
  }
}

class VideoListItem extends StatelessWidget {
  final Map<String, dynamic> videoInfo;

  VideoListItem(this.videoInfo);

  @override
  Widget build(BuildContext context) {

    //Declarando os atributos a serem no app
    final String title = videoInfo['title'];
    final String subtitle=videoInfo['subtitle'];
    final String thumbUrl = videoInfo['thumb'];
    final String videoUrl = videoInfo['sources'][0];

    //Inicio do link que contem a thumb e o titulo do video
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      leading: Image.network(
        thumbUrl,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      ),
      //Inicio do metodo de redirecionamento para a widget de inicializacao do video
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPlayerScreen(videoUrl: videoUrl),
          ),
        );
      },
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  VideoPlayerScreen({required this.videoUrl});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      })
      ..setVolume(1.0)
      ..play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
      ),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        )
            : CircularProgressIndicator(),
      ),
      //Inicio do floating button responsavel por fazer o play do video
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_controller.value.isPlaying) {
            _controller.pause();
          } else {
            _controller.play();
          }
          setState(() {});
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
