// ignore_for_file: constant_identifier_names
import 'package:awesome_dialog/awesome_dialog.dart';
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int score = 0;
  bool isGameRunning = false;
  bool isGameOver = false;
  late Timer timer;
  SnakeDirection snakeDirection = SnakeDirection.Down;
  int foodPosition = 200;
  List<int> snakePosition = [];
  void initializeSnake() {
    for (int i = 0; i < 3; i++) {
      snakePosition.add(i);
    }
  }

  void startGame() {
    isGameRunning = true;
    timer = Timer.periodic(
      const Duration(milliseconds: 300),
      (timer) {
        moveSnake();
        gameOver();
      },
    );
  }

  void moveSnake() {
    if (snakeDirection == SnakeDirection.Right) {
      if (snakePosition.last % 15 == 14) {
        snakePosition.add(snakePosition.last + 1 - 15);
      } else {
        snakePosition.add(snakePosition.last + 1);
      }
      // snakePosition.removeAt(0);
    } else if (snakeDirection == SnakeDirection.Left) {
      if (snakePosition.last % 15 == 0) {
        snakePosition.add(snakePosition.last - 1 + 15);
      } else {
        snakePosition.add(snakePosition.last - 1);
      }

      // snakePosition.removeAt(0);
    } else if (snakeDirection == SnakeDirection.Up) {
      if (snakePosition.last < 15) {
        snakePosition.add(snakePosition.last - 15 + 330);
      } else {
        snakePosition.add(snakePosition.last - 15);
      }

      // snakePosition.removeAt(0);
    } else if (snakeDirection == SnakeDirection.Down) {
      if (snakePosition.last > 314) {
        snakePosition.add(snakePosition.last + 15 - 330);
      } else {
        snakePosition.add(snakePosition.last + 15);
      }
    }
    if (snakePosition.last == foodPosition) {
      onEatFood();
    } else {
      snakePosition.removeAt(0);
    }
    setState(() {});
  }

  void onEatFood() {
    score++;
    while (snakePosition.contains(foodPosition)) {
      foodPosition = Random().nextInt(329);
    }
  }

  void gameOver() {
    print("check gameover");
    List<int> duplicateSnakePosition = [];
    duplicateSnakePosition.addAll(snakePosition);
    duplicateSnakePosition.remove(snakePosition.last);
    if (duplicateSnakePosition.contains(snakePosition.last)) {
      print("Game over");
      timer.cancel();
      isGameOver = true;

      setState(() {});
      AwesomeDialog(
        context: context,
        animType: AnimType.scale,
        dialogType: DialogType.error,
        body: const Center(
          child: Text(
            'Game Over!',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        title: "Score $score",
        desc: 'RestartGame',
        btnOkOnPress: () {
          restartGame();
        },
      ).show();
    }
  }

  void restartGame() {
    isGameOver = false;
    score = 0;
    snakePosition = [];
    initializeSnake();
    startGame();
  }

  @override
  void initState() {
    super.initState();
    initializeSnake();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await dialogueOpen();
    });
  }

  dialogueOpen() {
    AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.info,
      body: const Center(
        child: Text(
          'Welcome Again!',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
      title: 'Start the Game',
      btnOkOnPress: () {
        startGame();
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (DragUpdateDetails) {
        if (DragUpdateDetails.delta.dy > 0) {
          snakeDirection = SnakeDirection.Down;
          print("downward");
        } else {
          snakeDirection = SnakeDirection.Up;
          print("upward");
        }
        setState(() {});
      },
      onHorizontalDragUpdate: (DragUpdateDetails) {
        if (DragUpdateDetails.delta.dx > 0) {
          print("right");
          snakeDirection = SnakeDirection.Right;
        } else {
          snakeDirection = SnakeDirection.Left;
          print("left");
        }
        setState(() {});
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade300,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black),
                ),
                padding: const EdgeInsets.all(8),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 330,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 15,
                    crossAxisSpacing: 1.5,
                    mainAxisSpacing: 1.5,
                  ),
                  itemBuilder: (context, index) {
                    if (index == foodPosition) {
                      return const Food();
                    } else if (snakePosition.contains(index)) {
                      return const Snake();
                    } else {
                      return Box(index: index);
                    }
                  },
                ),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     Text(
              //       "Score : $score",
              //       style: const TextStyle(
              //         color: Colors.white,
              //         fontSize: 18,
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //     isGameRunning
              //         ? const SizedBox()
              //         : InkWell(
              //             onTap: () {
              //               startGame();
              //             },
              //             child: const Text(
              //               "Start Game",
              //               style: TextStyle(
              //                 color: Colors.white,
              //                 fontSize: 18,
              //                 fontWeight: FontWeight.bold,
              //               ),
              //             ),
              //           ),
              //     isGameOver
              //         ? InkWell(
              //             onTap: () {
              //               restartGame();
              //             },
              //             child: const Text(
              //               "Restart Game",
              //               style: TextStyle(
              //                 color: Colors.white,
              //                 fontSize: 18,
              //                 fontWeight: FontWeight.bold,
              //               ),
              //             ),
              //           ),

              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }
}

class Box extends StatelessWidget {
  final int index;
  const Box({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green,
        border: Border.all(
          width: 0,
          color: Colors.green,
        ),
        borderRadius: BorderRadius.circular(
          0,
        ),
      ),
    );
  }
}

class Food extends StatelessWidget {
  const Food({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.red);
  }
}

class Snake extends StatelessWidget {
  const Snake({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
    );
  }
}

enum SnakeDirection {
  Up,
  Down,
  Right,
  Left,
}
