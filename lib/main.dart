import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snacke/walksnacke.dart';

import 'Home.dart';

void main()
{
  runApp(MaterialApp(
    routes: {
      'home':(context) => Home(),
      'again':(context) => walksnacke(),
    },
    initialRoute: 'home',debugShowCheckedModeBanner: false,
  ));
}
