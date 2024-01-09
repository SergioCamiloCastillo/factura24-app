import 'package:flutter/material.dart';

const colorSeed = Color(0xFF06B981);

class AppTheme {
  ThemeData getTheme() {
    return ThemeData( colorSchemeSeed: colorSeed, useMaterial3: true);
  }
}
