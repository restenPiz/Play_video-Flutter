import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'firstScreen.dart';

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
                //Metodo para fechar a applicacao
                SystemNavigator.pop();
              },
            ),
            //Fim dos links do menug
            // Adicione mais itens de menu conforme necessário
          ],
        ),
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
