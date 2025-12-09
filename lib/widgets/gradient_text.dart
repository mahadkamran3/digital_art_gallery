import 'package:flutter/material.dart';
// Avoid runtime web font fetching to prevent failures when fonts.gstatic.com is blocked.
// Use a local/default TextStyle so the app runs on web and mobile without external font requests.

class GradientText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;

  const GradientText({
    super.key,
    required this.text,
    this.fontSize = 20,
    this.fontWeight = FontWeight.bold,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Colors.blueAccent, Colors.orangeAccent, Colors.greenAccent],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bounds),
      child: Text(
        text,
        // Use the platform default font. If you later add a bundled font in
        // pubspec.yaml (e.g., Pacifico), set fontFamily: 'Pacifico' here.
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: Colors.white, // This will be masked by the gradient
        ),
      ),
    );
  }
}
