import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int head = 5;
  List body = [4];
  int move = 1;
  int col = 10;
  int row = 10;
  int food = Random().nextInt(100);
  int pixel = 25;
  int score = 0;
  bool gameOn = false;
  int speed = 600;

  @override
  void initState() {
    super.initState();
    reset();
  }

  loop() async {
    while (gameOn)
      await Future.delayed(Duration(milliseconds: speed)).then(
        (value) {
          setState(() {
            walk();
          });
        },
      );
  }

  reset() {
    head = 5;
    body = [4];
    move = 1;
    food = Random().nextInt(100) <= 5 ? 15 : Random().nextInt(100);
    score = 0;
    speed = 600;
    if(!gameOn){
      gameOn = true;
      loop();
    }
    setState(() {});
  }

  walk() {
    //body walk behind the head
    for (int i = body.length - 1; i > 0; i--) body[i] = body[i - 1];
    body[0] = head;

    head_move();
    eat_food();
  }

  head_move() {
    if (head < 0 || head > row * col) {
      head = 5;
      move = 1;
    }
    //Continue walk snack
    List LeftToRight = [for (int i = 0; i <= row; i++) head == col * i - 1];
    List RightToLeft = [for (int i = 0; i <= row; i++) head == col * i];
    List UpToDown = [for (int i = 0; i < col; i++) head == col * row - col + i];
    List DownToUp = [for (int i = 0; i < col; i++) head == i];

    if (LeftToRight.contains(true) && move == 1)
      head -= col - 1;
    else if (RightToLeft.contains(true) && move == -1)
      head += col - 1;
    else if (UpToDown.contains(true) && move == col)
      head -= col * row - col;
    else if (DownToUp.contains(true) && move == 0 - col)
      head += col * row - col;
    else
      head += move;

    gameOn=isgame_over();
    setState(() {});
  }

  sound(String a)
  async {
    final player = AudioPlayer();
    await player.play(AssetSource(a));
  }

  isgame_over() {
    if (body.contains(head)) {
      if(gameOn)
      sound('audio/game_over.wav');
      return false;
    } else return true;
  }

  eat_food() {


    if (head == food) {
    sound('audio/eat.mp3');
      body.insert(0, head);
      head_move();
      do {
        food = Random().nextInt(col * row);
      } while (body.contains(food) || food == head);
      score += 10;
      speed -=20;
    }
  }

  double width = 0;
  double height = 0;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top +
            MediaQuery.of(context).padding.bottom +
            100);
    double width = MediaQuery.of(context).size.width;
    col = (width / pixel).floor();
    row = (height / pixel).floor();

    return Scaffold(
      appBar: AppBar(
        title: Text('${isgame_over() ? "Score : $score" : "Game over"}'),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    gameOn=false;
                    return AlertDialog(
                      title: ElevatedButton(
                          onPressed: () {
                              pixel += 5;
                              head = 5;
                              body = [4];
                              do {
                                food = Random().nextInt(
                                    (width / pixel).floor() *
                                        (height / pixel).floor());
                              } while (body.contains(food) || food == head);
                              Navigator.pop(context);
                              reset();
                              setState(() {});
                          },
                          child: Text('Play')),
                    );
                  },
                );
                setState(() {});
              },
              icon: Icon(CupertinoIcons.left_chevron)),
          ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    gameOn=false;
                    return AlertDialog(
                      title: ElevatedButton(
                          onPressed: () {
                            reset();
                            Navigator.pop(context);
                          },
                          child: Text('Play')),
                    );
                  },
                );
                setState(() {});
              },
              child: Text('Reset')),
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    gameOn=false;
                    return AlertDialog(
                      title: ElevatedButton(
                          onPressed: () {
                            pixel -= 5;
                            head = 5;
                            body = [4];
                            do {
                              food = Random().nextInt(
                                  (width / pixel).floor() * (height / pixel).floor());
                            } while (body.contains(food) || food == head);
                            Navigator.pop(context);
                            reset();
                            setState(() {});

                          },
                          child: Text('Play')),
                    );
                  },
                );
                setState(() {});
              },
              icon: Icon(CupertinoIcons.right_chevron)),
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          children: [
            SizedBox(
              width: width,
              height: row * pixel * pixel * col + row + 0,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: col),
                itemCount: row * col,
                itemBuilder: (context, index) {
                  return get(index);
                },
              ),
            ),
            SwipeDetector(
                onSwipe: (direction, offset) {
                  switch (direction) {
                    case SwipeDirection.up:
                      move = 0 - col;
                      // print('Swiped up');
                      break;
                    case SwipeDirection.down:
                      move = col;
                      // print('Swiped down');
                      break;
                    case SwipeDirection.left:
                      move = -1;
                      // print('Swiped left');
                      break;
                    case SwipeDirection.right:
                      move = 1;
                      // print('Swiped right');
                      break;
                  }
                },
                child: Container(
                  color: Colors.transparent,
                  height: double.infinity,
                  width: double.infinity,
                )),
          ],
        ),
      ),
    );
  }

  Widget get(int a) {
    String h = "";
    if (move == 1) h = 'assets/image/right.png';
    if (move == -1) h = 'assets/image/left.png';
    if (move == col) h = 'assets/image/down.png';
    if (move == 0 - col) h = 'assets/image/up.png';

    if (a == head)
      return Container(
        color: Colors.black,
        child: Image(image: AssetImage(h)),
      );
    else if (body.contains(a))
      return Container(
          color: Colors.black,
          child: Container(
            margin: EdgeInsets.all(a == body[body.length - 1] ? 5 : 2),
            decoration: BoxDecoration(
                color: Color(0xff8dc63f),
                borderRadius: BorderRadius.all(
                    Radius.circular(a == body[body.length - 1] ? 6 : 5))),
            child: a == body[body.length - 1]
                ? null
                : Container(
                    margin: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.circular(10)),
                  ),
          ));
    else if (food == a)
      return Container(
        color: Colors.black,
        child: Image(image: AssetImage('assets/image/food.png')),
      );
    else
      return Container(
        color: Colors.black,
      );
  }
}
