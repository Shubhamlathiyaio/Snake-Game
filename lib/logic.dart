import 'package:get/get.dart';

class logic extends GetxController
{
  RxInt head = 5.obs;
  RxList body = [4, 3, 2, 1].obs;
  walk(int col,int row,int move) {
    //body walk behind the head
    for (int i = body.length - 1; i > 0; i--)
      body[i] = body[i - 1];
    body[0] = head;

    //Continue walk snack
    List LeftToRight = [for (int i = 0; i <= row; i++) head == col * i - 1];
    List RightToLeft = [for (int i = 0; i <= row; i++) head == col * i];
    List UpToDown = [
      for (int i = 0; i < col; i++) head == col * row - col + i + 1
    ];
    List DownToUp = [for (int i = 0; i < col; i++) head == i];

    print('Head = $head');
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
  }

}