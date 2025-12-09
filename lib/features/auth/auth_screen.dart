import 'package:flutter/material.dart';
import '../../widgets/gradient_text.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const GradientText(text: 'Sign In / Sign Up')),
      body: Container(
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/images/background02.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
          ),
          color: Colors.white.withOpacity(0.0),
        ),
        child: Center(
          child: Text(
            'Authenticate to showcase or explore art!',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ),
    );
  }
}
