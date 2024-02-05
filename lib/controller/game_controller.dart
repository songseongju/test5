import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class GameController extends GetxController {

  final List<String> choices = ['가위', '바위', '보'];
  // final playerChoice = RxnString();
  RxString playerChoice = ''.obs;
  // final computerChoice = RxnString();
  RxString computerChoice = ''.obs;
  //final result = RxnString();
  RxString result = ''.obs;
  // final roundsPlayed = RxnInt();
  RxInt roundsPlayed = 0.obs;
  //final gameInProgress = RxnBool();
  RxBool gameInProgress = true.obs;
  // final remainingTime = RxnString();
  RxString remainingTime = '00:00'.obs;

  DateTime? endTime;



  // SharedPreferences 키 값
  final String roundsPlayedKey = 'roundsPlayed';
  final String endTimeKey = 'endTime';

  @override
  void onInit() {
    super.onInit();
    ever(roundsPlayed, (int value) {
      if (value >= 5) {
        gameInProgress.value = false;
        startTimer();
      }
    });
    //    _loadGameData();
  }

  // 게임 로직
  void playGame(String playerChoice) {
    this.playerChoice.value = playerChoice;
    this.computerChoice.value = choices[Random().nextInt(choices.length)];

    if (this.playerChoice.value == this.computerChoice.value) {
      result.value = '무승부';
    } else
    if ((this.playerChoice.value == '가위' && this.computerChoice.value == '보') ||
        (this.playerChoice.value == '바위' &&
            this.computerChoice.value == '가위') ||
        (this.playerChoice.value == '보' && this.computerChoice.value == '바위')) {
      result.value = '플레이어 승리';
    } else {
      result.value = '컴퓨터 승리';
    }

    roundsPlayed.value++;

    if (roundsPlayed.value >= 5) {
      gameInProgress.value = false;
    }
   showCooldownDialog();
  }


  // void showCooldownDialog() {
  //   Get.dialog(
  //     AlertDialog(
  //       title: Text('횟수 제한'),
  //       content: Text('횟수를 모두 소진하셨습니다. 5분 휴식 후 다시 시작 해 주세요!'),
  //       actions: [
  //         TextButton(
  //           onPressed: () {
  //             Get.back(); // 다이얼로그 닫기
  //             roundsPlayed.value = 0;
  //             gameInProgress.value = true;
  //             result.value = '';
  //             remainingTime.value = '00:00';
  //             _saveGameData();
  //           },
  //           child: Text('확인'),
  //         ),
  //       ],
  //     ),
  //     barrierDismissible: false,
  //   );
  // }

  void showCooldownDialog() {


    try {
      if (Get.isRegistered<GameController>()) {
        Get.dialog(
          AlertDialog(
            title: Text('횟수 제한'),
            content: Text('총 $roundsPlayed 회 하셨습니다. 총 5판 후 5분 휴식입니다.'),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back(); // 다이얼로그 닫기
                  if (Get.isRegistered<GameController>()) {
                    final controller = Get.find<GameController>();
                   // controller.roundsPlayed.value = 0;
                    controller.gameInProgress.value = true;
                    controller.result.value = '';
                    controller.remainingTime.value = '00:00';
                    if(controller.roundsPlayed >= 5){
                      controller.gameInProgress.value = false;
                    }
                  }
                },
                child: Text('확인'),
              ),
            ],
          ),
          barrierDismissible: false,
        );
      } else {
        print('GameController not registered.');
      }
      } catch (e) {
       print('첫번쨰 다이얼로그 예외 발생: $e');
    }
  }


  // void showCooldownDialog() {
  //   Get.defaultDialog(
  //     title: '횟수 제한',
  //     middleText: '횟수를 모두 소진하셨습니다. 5분 휴식 후 다시 시작 해 주세요',
  //     textConfirm: '확인',
  //     confirmTextColor: Colors.white,
  //     onConfirm: () {
  //       roundsPlayed.value = 0;
  //       gameInProgress.value = true;
  //       result.value = '';
  //       remainingTime.value = '00:00';
  //     },
  //   );
  // }


  void startTimer() {
    const Duration roundDuration = Duration(minutes: 5);
    endTime = DateTime.now().add(roundDuration);

    void updateRemainingTime() {
      Duration remaining = endTime!.difference(DateTime.now());
      remainingTime.value =
      '${remaining.inMinutes.remainder(60).toString().padLeft(
          2, '0')}:${remaining.inSeconds.remainder(60).toString().padLeft(
          2, '0')}';
    }

    updateRemainingTime(); // 초기화

    Timer.periodic(Duration(seconds: 1), (Timer timer) {
      updateRemainingTime();
      if (DateTime.now().isAfter(endTime!)) {
        timer.cancel();
        showCooldownDialog2();
      }
    });
  }

  // void showCooldownDialog2() {
  //   Get.defaultDialog(
  //     title: '쿨타임 종료',
  //     middleText: '5분 동안의 쿨타임이 종료되었습니다. 게임을 다시 시작하세요!',
  //     textConfirm: '확인',
  //     confirmTextColor: Colors.white,
  //     onConfirm: () {
  //       roundsPlayed.value = 0;
  //       gameInProgress.value = true;
  //       result.value = '';
  //       remainingTime.value = '00:00';
  //     },
  //   );
  // }

  void showCooldownDialog2() {
    try {
      Get.dialog( //다이얼로그 열기
        AlertDialog(
          title: Text('쿨타임 종료'),
          content: Text('5분 동안의 쿨타임이 종료되었습니다. 게임을 다시 시작하세요!'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // 다이얼로그 닫기
                roundsPlayed.value = 0;
                gameInProgress.value = true;
                result.value = '';
                remainingTime.value = '00:00';
                // 초기화
              },
              child: Text('확인'),
            ),
          ],
        ),
        barrierDismissible: false, // 사용자가 종료 못하게 만듬
      );
    } catch (e) {
      print('두번째 다이얼로그 예외 발생: $e');
    }
  }

  // 게임 데이터를 SharedPreferences에 저장
  Future<void> _saveGameData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt(roundsPlayedKey, roundsPlayed.value);
      if (endTime != null) {
        prefs.setString(endTimeKey, endTime.toString());
      }
    } catch (e) {
      print('데이터 저장 예외발생 : $e');
    }
  }
  // 저장된 게임 데이터를 불러오기
  Future<void> _loadGameData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      roundsPlayed.value = prefs.getInt(roundsPlayedKey) ?? 0;

      String? savedEndTime = prefs.getString(endTimeKey);
      if (savedEndTime != null) {
        endTime = DateTime.parse(savedEndTime);
        if (DateTime.now().isBefore(endTime!)) {
          // 유효성 검사 시간이 지났는지
          gameInProgress.value = false;
          startTimer();
        }
      }
    } catch (e) {
      print('데이터 불러오기 예외발생 : $e');
    }
  }
}



