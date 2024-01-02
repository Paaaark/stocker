import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      "Hello",
      style: TextStyle(
        color: Theme.of(context).textTheme.displayLarge?.color,
      ),
    );
  }
}
