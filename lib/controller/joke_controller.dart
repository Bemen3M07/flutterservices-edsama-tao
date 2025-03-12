import '../../model/joke_model.dart';

class JokeController {
  Future<String> getRandomJoke() async {
    try {
      final joke = await JokeModel.fetchRandomJoke();
      return joke;
    } catch (e) {
      return 'Error al cargar: $e';
    }
  }
}
