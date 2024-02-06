import 'package:flutter/material.dart';

class walksnacke extends StatefulWidget {
  const walksnacke({super.key});

  @override
  State<walksnacke> createState() => _walksnackeState();
}

class _walksnackeState extends State<walksnacke> {
  int a=0;

  void initState()
  {
    print('start');
    fun();
  }

  fun()
  async {
    while(true)
    await Future.delayed(Duration(milliseconds: 200)).then((value) {
      setState(() {
        a+=50;
      });
    },);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('$a',style: TextStyle(fontSize: 72),),)
    );
  }
}
