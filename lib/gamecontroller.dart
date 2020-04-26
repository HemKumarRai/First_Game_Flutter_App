import 'dart:math';
import 'dart:ui';

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:game1/player.dart';
import 'package:game1/score_text.dart';
import 'package:game1/start_button.dart';
import 'package:game1/state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'enemy.dart';
import 'enemy_spawner.dart';
import 'health_bar.dart';
import 'highscore_text.dart';

class GameController extends Game {
  final SharedPreferences storage;
  Random rand;
  var screenSize;
  var tileSIze;
  Player player;
  EnemySpawner enemySpawner;
  List<Enemy> enemies;
  HealthBar healthBar;
  int score;
  ScoreText scoreText;
  HighscoreText highScoreText;

  StartText startText;
  Steta state;
  GameController(this.storage) {
    initialize();
  }
  void initialize() async {
    resize(await Flame.util.initialDimensions());
    state = Steta.menu;
    rand = Random();
    player = Player(this);
    enemySpawner = EnemySpawner(this);
    enemies = List<Enemy>();
    healthBar = HealthBar(this);
    score = 0;
    scoreText = ScoreText(this);
    highScoreText = HighscoreText(this);
    startText = StartText(this);
    spawnEnemy();
  }

  void render(Canvas c) {
    Rect background =
        Rect.fromLTWH(0.0, 0.0, screenSize.width, screenSize.height);
    Paint backgroundPaint = Paint()..color = Color(0xFFFAFAFA);
    c.drawRect(background, backgroundPaint);
    player.render(c);

    if (state == Steta.menu) {
      startText.render(c);
      highScoreText.render(c);
    } else if (state == Steta.playing) {
      enemies.forEach((Enemy enemy) => enemy.render(c));

      enemies.forEach((Enemy enemy) => enemy.render(c));
      scoreText.render(c);
      healthBar.render(c);
    }
  }

  void update(double t) {
    if (state == Steta.menu) {
      startText.update(t);
      highScoreText.update(t);
    } else if (state == Steta.playing) {
      enemySpawner.update(t);
      enemies.forEach((Enemy enemy) => enemy.update(t));
      enemies.removeWhere((Enemy enemy) => enemy.isDead);
      player.update(t);
      scoreText.update(t);
      healthBar.update(t);
    }
  }

  void resize(Size size) {
    screenSize = size;
    tileSIze = screenSize.width / 10;
  }

  void onTapDown(TapDownDetails d) {
    if (state == Steta.menu) {
      state = Steta.playing;
    } else if (state == Steta.playing) {
      enemies.forEach((Enemy enemy) {
        if (enemy.enemyRect.contains(d.globalPosition)) {
          enemy.onTapDown();
        }
      });
    }
  }

  void spawnEnemy() {
    double x, y;
    switch (rand.nextInt(4)) {
      case 0:
        //TOp
        x = rand.nextDouble() * screenSize.width;
        y = -tileSIze * 2.5;
        break;

      case 1:
        //Right
        x = screenSize.width * tileSIze * 2.5;
        y = rand.nextDouble() * screenSize.height;
        break;

      case 2:
        //Bottom
        x = rand.nextDouble() * screenSize.width;
        y = screenSize.height * tileSIze * 2.5;
        break;
      case 3:
        //Left
        x = -tileSIze * 2.5;
        y = rand.nextDouble() * screenSize.height;
        break;
    }
    enemies.add(Enemy(this, x, y));
  }
}

