import 'package:flutter/material.dart';

class MyTheme {
  ThemeData theme = ThemeData(
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: Color.fromARGB(255, 212, 212, 212),
      ),
    ),
    cardColor: const Color(0xFFF4EDDB),
    colorScheme:
        const ColorScheme.dark(background: Color.fromARGB(255, 44, 44, 44)),
  );
}
