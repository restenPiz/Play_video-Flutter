import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:video_player/video_player.dart';

class firstScreen extends StatefulWidget {
  const firstScreen();

  @override
  State<firstScreen> createState() => _State();
}

class _State extends State<firstScreen> {
  List<String> videoUrls = [];
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // Início do método responsável por fazer o GET de todos os dados da API
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video List'),
      ),
      body: ListView.builder(
        itemCount: videoUrls.length,
        itemBuilder: (context, index) {
          _controller = VideoPlayerController.network(videoUrls[index]);
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
