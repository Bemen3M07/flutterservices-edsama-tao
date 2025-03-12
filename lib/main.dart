import 'package:flutter/material.dart';
import '../controller/joke_controller.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Widget raiz de la APP
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chistes Chistosos',
      home: JokeView(),
    );
  }
}

class JokeView extends StatefulWidget {
  @override
  _JokeViewState createState() => _JokeViewState();
}

class _JokeViewState extends State<JokeView> {
  final JokeController _controller = JokeController();
  String _joke = 'Dale al boton para ver el chiste';

  @override
  void initState() {
    super.initState();
    _fetchJoke();
  }

  // Función que pide el chiste al controlador.
  void _fetchJoke() async {
    final joke = await _controller.getRandomJoke();
    setState(() {
      _joke = joke;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chistesito aleatorio'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _joke,
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchJoke,
        tooltip: 'OTRO!',
        child: Icon(Icons.refresh),
      ),
    );
  }
}
