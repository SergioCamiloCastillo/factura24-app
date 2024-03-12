import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {
  final Color color;
  const FullScreenLoader({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Center(
        child: CircularProgressIndicator.adaptive(
          backgroundColor: color,
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    );
  }
}
