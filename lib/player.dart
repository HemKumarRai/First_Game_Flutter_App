import 'dart:ui';

import 'package:game1/gamecontroller.dart';

class Player {
  final GameController gameController;
  Size screenSize;
  double tileSize;
  int maxHealth;
  int currentHealth;
  Rect playerRect;
  bool isDead = false;
  Player(this.gameController) {
    maxHealth = currentHealth = 300;
    final size = gameController.tileSIze * 1.5;
    playerRect = Rect.fromLTWH(gameController.screenSize.width / 2,
        gameController.screenSize.height / 2, size, size);
  }
  void render(Canvas c) {
    Rect background =
        Rect.fromLTWH(0, 9, screenSize.width / 2, screenSize.height / 2);
    Paint backgroundPaint = Paint()..color = Color(0xFFAFAFA);
    c.drawRect(background, backgroundPaint);
  }

  void update(double t) {
    print(currentHealth);
    if (!isDead && currentHealth <= 0) {
      isDead = true;
      gameController.initialize();
    }
  }

  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.width / 10;
  }
}
