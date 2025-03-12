import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class Joke {
  final int id;
  final String joke;

  Joke({required this.id, required this.joke});

  factory Joke.fromJson(Map<String, dynamic> json) {
    return Joke(
      id: json['id'],
      joke: "${json['setup']}\n${json['punchline']}",
    );
  }
}

class JokeModel {
  static const String _baseUrl = 'https://api.sampleapis.com/jokes/goodJokes';

  // Función que recoge todos los chistes de la api y devuelve uno aleatorio.
  static Future<String> fetchRandomJoke() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> jokesJson = jsonDecode(response.body);
      if (jokesJson.isNotEmpty) {
        final randomIndex = Random().nextInt(jokesJson.length);
        final Joke joke = Joke.fromJson(jokesJson[randomIndex]);
        return joke.joke;
      } else {
        return 'No hay chistes disponibles.';
      }
    } else {
      throw Exception('Error al cargar chistes');
    }
  }
}
