import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Home.dart';

void main()
{
  runApp(MaterialApp(
    routes: {
      'home':(context) => Home(),
    },
    initialRoute: 'home',debugShowCheckedModeBanner: false,
  ));
}
