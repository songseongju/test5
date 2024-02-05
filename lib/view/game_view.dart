import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test5/controller/game_controller.dart';

class GameScreen extends StatelessWidget {

  final GameController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(() => Text(
            '플레이어 선택: ${controller.playerChoice}',
            style: TextStyle(fontSize: 20),
          )),
          SizedBox(height: 20),
          Obx(() => Image.asset(
            'assets/images/${controller.computerChoice.value}test.png',
            height: 100,
          )),
          SizedBox(height: 20),
          Obx(() => Text(
            '결과: ${controller.result}',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          )),
          SizedBox(height: 20),
          Obx(() => Text(
            '횟수: ${controller.roundsPlayed} / 5 ',
            style: TextStyle(fontSize: 20),
          )),
          SizedBox(height: 20),
          Obx(() {
            if (controller.gameInProgress.value) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: controller.choices
                    .map((choice) => ElevatedButton(
                  onPressed: () {
                    controller.playGame(choice);
                  },
                  child: Text(choice),
                ))
                    .toList(),
              );
            } else {
              return Text(
                '게임 종료! ${controller.roundsPlayed} 번 플레이했습니다.',
                style: TextStyle(fontSize: 20),
              );
            }
          }),
          SizedBox(height: 20),
          Obx(() => Text(
            '남은 시간: ${controller.remainingTime}',
            style: TextStyle(fontSize: 20),
          )),
        ],
      ),
    );
  }
}