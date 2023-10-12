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

  //Inicio do metodo para fazer o fetch de todos os dados da API
  Future<void> fetchData() async {
    //Inicio da URl responsavel por retornar a URL com os dados em Json
    final response = await http.get(
        Uri.parse('https://raw.githubusercontent.com/bikashthapa01/myvideos-android-app/master/data.json'));

    //Metodo de resposta em detrimento da resposta da API
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.containsKey('categories') && data['categories'] is List<dynamic>) {
        setState(() {
          videoData = List<Map<String, dynamic>>.from(data['categories'][0]['videos']);
        });
      } else {
        print('Dados inválidos na resposta da API.');
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
      //Incio do titulo do AppBar
      appBar: AppBar(
        title: Text('Resten - Play'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const UserAccountsDrawerHeader(
              accountName: Text("Mauro Peniel"),
              accountEmail: Text("contacto@mauropeniel.info"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person),
              ),
            ),
            //Inicio dos links do menug
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Início'),
              onTap: () {
                // Navegar para a tela inicial ou qualquer outra tela
              },
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text('Ajuda'),
              onTap: () {
                // Navegar para a tela inicial ou qualquer outra tela
              },
            ),
            ListTile(
              leading: Icon(Icons.close),
              title: Text('Sair'),
              onTap: () {
                // Navegar para a tela inicial ou qualquer outra tela
              },
            ),
            // Adicione mais itens de menu conforme necessário
          ],
        ),
      ),
      //Inicio da widget que responsavel por listar todos os listViews
      body: ListView.builder(
        itemCount: videoData.length,
        itemBuilder: (context, index) {
          final video = videoData[index];
          return ListTile(
            //Inicio da thumb,titulo e subtitulo das listviews
            title: Text(video['title'] ?? 'Video $index'),
            subtitle: Text(video['subtitle'] ?? ''),
            leading: Image.network(video['thumb'] ?? ''),

            //Inicio do metodo responsavel por fazer o redirecionamento para a outra widget
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoPlayerScreen(videoUrl: video['sources'][0]),
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
  final String videoUrl;

  VideoPlayerScreen({required this.videoUrl});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;

  //Inicio do metodo de mudanca de estado
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl);
    _controller.initialize().then((_) {
      setState(() {});
    });
  }

  //Inicio da widget responsavel por fazer o play do video
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resten - Play'),
      ),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        )
            : CircularProgressIndicator(),
      ),
      //Inicio do butao de playg
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_controller.value.isPlaying) {
            _controller.pause();
          } else {
            _controller.play();
          }
          setState(() {});
        },
        //Inicio do icone de play e pause no butaog
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
