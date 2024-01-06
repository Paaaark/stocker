import 'package:flutter/material.dart';

class MyTheme {
  ThemeData theme = ThemeData(
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: Color.fromARGB(255, 212, 212, 212),
      ),
    ),
    primaryColorLight: const Color.fromARGB(255, 212, 212, 212),
    cardColor: const Color.fromARGB(255, 30, 30, 30),
    highlightColor: const Color.fromARGB(255, 44, 44, 44),
    colorScheme:
        const ColorScheme.dark(background: Color.fromARGB(255, 44, 44, 44)),
  );
}
