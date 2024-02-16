import 'dart:core';
import 'dart:math';

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
  List body = [4, 3, 2, 1];
  int move = 1;
  int col=10;
  int row=10;
  int food=Random().nextInt(100);
  int pixel=30;
  int score=0;
  bool gameOn=true;
  int speed=600;


  @override
  void initState() {
    super.initState();
    fun();
  }

  fun() async {
    while(gameOn)
      await Future.delayed(Duration(milliseconds: speed)).then((value) {
        setState(() {
          walk();
        });
      },);

  }
  reset() {
       head = 5;
       body = [4, 3, 2, 1];
       move = 1;
       food=Random().nextInt(100);
       score=0;
       speed=600;
       gameOn=true;
       fun();
       setState(() {});
  }

  walk() {
    //body walk behind the head
    for (int i = body.length - 1; i > 0; i--)
      body[i] = body[i - 1];
    body[0] = head;

    head_move();
    eat_food();
  }
  head_move() {
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

   isgame_over();
  }
  isgame_over()
  {
    if(body.contains(head))
    {
      gameOn=false;
      setState(() {});
    }
  }

  eat_food() {
    if(head==food)
    {
      body.insert(0, head);
      head_move();
      food=Random().nextInt(col*row);
      score+=10;
      speed=(600-(5*score)).toInt();
    }
  }

  double width=0;
  double height=0;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height - (MediaQuery.of(context).padding.top+MediaQuery.of(context).padding.bottom+50);
    double width = MediaQuery.of(context).size.width;
    col = (width / pixel).floor();
    row = (height / pixel).floor();

    return Scaffold(
      appBar: AppBar(title: Text('${gameOn ? score : "Game over"}'),actions: [
        IconButton(onPressed: () {
          setState(() {
            pixel+=10;
            reset();
          });
        }, icon: Icon(CupertinoIcons.left_chevron)),
        ElevatedButton(onPressed: () {
          setState(() {
            reset();
          });
        }, child: Text('Reset')),
        IconButton(onPressed: () {
          setState(() {
            pixel-=10;
            reset();
          });
        }, icon: Icon(CupertinoIcons.right_chevron)),
      ],),
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          children: [
          SizedBox(
          width: width,
          height:row*pixel*pixel*col+row+0,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: col,
                mainAxisSpacing: 1,
                crossAxisSpacing: 1),
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
    if (a == head)
      return Container(
        color: Colors.red,
      );
    else if (body.contains(a)) return Container(
        color: Colors.green,
      );
    else if (food==a) return Container(color: Colors.yellow,);
    else
      return Container(
        color: Colors.black,
      );
  }
}