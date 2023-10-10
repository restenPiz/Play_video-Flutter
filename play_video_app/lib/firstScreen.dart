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
  List<String> videoUrls = [];

  //Inicio do metodo responsavel por fazer o fetch dos dados da API
  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('https://raw.githubusercontent.com/bikashthapa01/myvideos-android-app/master/data.json'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data.containsKey('categories') && data['categories'] is List<dynamic>) {
        final categories = List<dynamic>.from(data['categories']);
        List<String> allVideoUrls = [];

        for (var category in categories) {
          if (category.containsKey('videos') && category['videos'] is List<dynamic>) {
            final videos = List<dynamic>.from(category['videos']);

            for (var video in videos) {
              if (video.containsKey('sources') && video['sources'] is List<dynamic>) {
                final sources = List<dynamic>.from(video['sources']);
                allVideoUrls.addAll(sources.map((source) => source.toString()));
              }
            }
          }
        }

        setState(() {
          videoUrls = allVideoUrls;
        });
      } else {
        print('Chave "categories" não encontrada ou não é uma lista válida.');
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
        title: Text('Video Player'),
      ),
      body: ListView.builder(
        itemCount: videoUrls.length,
        itemBuilder: (context, index) {
          VideoPlayerController _controller = VideoPlayerController.network(videoUrls[index]);
          _controller.initialize();

          //Inicio da widget que retorna os nomes dos videos
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

class VideoPlayerScreen extends StatefulWidget {
  final VideoPlayerController controller;

  VideoPlayerScreen({required this.controller});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  @override
  void initState() {
    super.initState();
    widget.controller.play();
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: widget.controller.value.aspectRatio,
          child: VideoPlayer(widget.controller),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (widget.controller.value.isPlaying) {
            widget.controller.pause();
          } else {
            widget.controller.play();
          }
          setState(() {});
        },
        child: Icon(
          widget.controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
