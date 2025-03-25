import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late SpaceShooterGame game;

  @override
  void initState() {
    super.initState();
    game = SpaceShooterGame(onGameOver: showGameOverScreen);
  }

  // Función que muestra la pantalla de Game Over
  void showGameOverScreen() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black54,
          title: Text('GAME OVER', style: TextStyle(fontSize: 48, color: Colors.white)),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el dialogo
                setState(() {
                  game.reset(); // Reinicia el juego
                });
              },
              child: Text('Reintentar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(game: game),
    );
  }
}

class SpaceShooterGame extends FlameGame with PanDetector, HasCollisionDetection {
  late Player player;
  final Function onGameOver;

  SpaceShooterGame({required this.onGameOver});

  late ParallaxComponent parallax;

  @override
  Color backgroundColor() => Colors.blue;

  @override
  Future<void> onLoad() async {
    // Cargar el fondo parallax con la forma correcta
    parallax = await loadParallaxComponent(
      [
        ParallaxImageData('stars_0.png'),
        ParallaxImageData('stars_1.png'),
        ParallaxImageData('stars_2.png'),
      ],
      baseVelocity: Vector2(0, -5), // Velocidad base
      repeat: ImageRepeat.repeat, // Repite la imagen
      velocityMultiplierDelta: Vector2(0, 5), // Aceleración de la velocidad
      fill: LayerFill.none,
    );
    add(parallax);

    // Crear y agregar al jugador
    player = Player();
    add(player);

    // Agregar enemigos al juego
    add(
      SpawnComponent(
        factory: (index) {
          return Enemy();
        },
        period: 1,
        area: Rectangle.fromLTWH(0, 0, size.x, -Enemy.enemySize),
      ),
    );
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    player.move(info.delta.global);
  }

  @override
  void onPanStart(DragStartInfo info) {
    player.startShooting();
  }

  @override
  void onPanEnd(DragEndInfo info) {
    player.stopShooting();
  }

  // Llamada a onGameOver cuando el jugador muere
  void gameOver() {
    onGameOver();
  }

  // Resetear el juego
  Future<void> reset() async {
    // Reiniciar el fondo parallax
    remove(parallax);
    parallax = await loadParallaxComponent(
      [
        ParallaxImageData('stars_0.png'),
        ParallaxImageData('stars_1.png'),
        ParallaxImageData('stars_2.png'),
      ],
      baseVelocity: Vector2(0, -5), // Velocidad base
      repeat: ImageRepeat.repeat, // Repite la imagen
      velocityMultiplierDelta: Vector2(0, 5),
      fill: LayerFill.none,
    );
    add(parallax);

    // Reiniciar la posición del jugador
    player.position = size / 2;
    add(player);

    // Reiniciar enemigos y balas
    children.whereType<Enemy>().forEach((enemy) => enemy.removeFromParent());
    children.whereType<Bullet>().forEach((bullet) => bullet.removeFromParent());
  }
}

class Player extends SpriteComponent with HasGameReference<SpaceShooterGame>, CollisionCallbacks {
  Player()
      : super(
          size: Vector2(100, 150),
          anchor: Anchor.center,
        );

  late final SpawnComponent _bulletSpawner;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await game.loadSprite('player.png');

    position = game.size / 2;

    _bulletSpawner = SpawnComponent(
      period: 0.2,
      selfPositioning: true,
      factory: (index) {
        return Bullet(
          position: position + Vector2(0, -height / 2),
        );
      },
      autoStart: false,
    );

    game.add(_bulletSpawner);
    add(RectangleHitbox());
  }

  void move(Vector2 delta) {
    position.add(delta);
  }

  void startShooting() {
    _bulletSpawner.timer.start();
  }

  void stopShooting() {
    _bulletSpawner.timer.stop();
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Enemy) {
      game.gameOver();
      removeFromParent();
    }
  }
}

class Bullet extends SpriteComponent with HasGameReference<SpaceShooterGame> {
  Bullet({super.position}) : super(size: Vector2(25, 50), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await game.loadSprite('bullet.png');


    add(RectangleHitbox(collisionType: CollisionType.passive));
  }

  @override
  void update(double dt) {
    super.update(dt);

    position.y += dt * -500;

    if (position.y < -height) {
      removeFromParent();
    }
  }
}

class Enemy extends SpriteAnimationComponent with HasGameReference<SpaceShooterGame>, CollisionCallbacks {
  Enemy({super.position})
      : super(size: Vector2.all(enemySize), anchor: Anchor.center);

  static const enemySize = 50.0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    animation = await game.loadSpriteAnimation(
      'enemy.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.2,
        textureSize: Vector2.all(16),
      ),
    );

    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    position.y += dt * 250;

    if (position.y > game.size.y) {
      removeFromParent();
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Bullet) {
      removeFromParent();
      other.removeFromParent();
      game.add(Explosion(position: position));
    }
  }
}

class Explosion extends SpriteAnimationComponent with HasGameReference<SpaceShooterGame> {
  Explosion({super.position})
      : super(size: Vector2.all(150), anchor: Anchor.center, removeOnFinish: true);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    animation = await game.loadSpriteAnimation(
      'explosion.png',
      SpriteAnimationData.sequenced(
        amount: 6,
        stepTime: 0.1,
        textureSize: Vector2.all(32),
        loop: false,
      ),
    );
  }
}
