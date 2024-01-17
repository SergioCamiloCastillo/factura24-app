import 'package:flutter/material.dart';

List<Map<String, dynamic>> globalColors = [
  {'nameColor': 'red', 'color': Colors.pinkAccent},
  {'nameColor': 'blue', 'color': Colors.lightBlue},
  {'nameColor': 'green', 'color': Colors.lightGreen},
  {'nameColor': 'yellow', 'color': Colors.yellowAccent},
  {'nameColor': 'purple', 'color': Colors.purpleAccent},
  {'nameColor': 'brown', 'color': const Color(0xFFB88E74)},
  {'nameColor': 'orange', 'color': Colors.orangeAccent},
  {'nameColor': 'beige', 'color': const Color(0xFFF5F5DC)},
  {'nameColor': 'pink', 'color': Colors.pinkAccent}
];
Color getColorByName(String nameColor) {
  final colorData = globalColors.firstWhere(
    (colorMap) => colorMap['nameColor'] == nameColor,
    orElse: () => {'color': Colors.black},
  );
  return colorData['color'];
}