import 'package:flutter/material.dart';
import 'package:nago/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nago',
      theme: ThemeData(
          accentColor: Color(0xFFFFC107),
          primaryColorDark: Color(0xffc7c7c7),
          primaryColor: Colors.white),
      home: ListPage(),
    );
  }
}
