import 'package:flutter/material.dart';

class MyTheme {
  ThemeData theme = ThemeData(
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: Colors.amber,
      ),
    ),
    cardColor: const Color(0xFFF4EDDB),
    colorScheme: const ColorScheme.dark(background: Color(0xFFE7626C)),
  );
}
