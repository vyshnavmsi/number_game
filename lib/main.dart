import 'package:flutter/material.dart';
import 'package:number_game/homescreen/number_drag_drop_page.dart';
import 'package:number_game/splash_screen/splashscreen.dart';

void main() {
  runApp(NumberDragDropGame());
}

class NumberDragDropGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Number Arrangement Game',
      home: Splashscreen(),
    );
  }
}
