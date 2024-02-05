import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test5/controller/game_controller.dart';
import 'package:test5/view/game_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final GameController controller = Get.put(GameController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('가위바위보 게임'),
        ),
        body: GameScreen(),
      ),
    );
  }
}