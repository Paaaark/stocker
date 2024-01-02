import 'package:flutter/material.dart';
import 'package:stocker/screens/MainScreen.dart';
import 'package:stocker/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stocker',
      theme: MyTheme().theme,
      home: MainScreen(),
    );
  }
}
