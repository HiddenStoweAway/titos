import 'package:flutter/material.dart';
import 'package:titos/colors_palette.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsPalette.primary,
      body: Center(
        child: Text(
          "LOADING",
          style: TextStyle(
              fontSize: 38,
              fontWeight: FontWeight.bold,
              color: ColorsPalette.colorB),
        ),
      ),
    );
  }
}
