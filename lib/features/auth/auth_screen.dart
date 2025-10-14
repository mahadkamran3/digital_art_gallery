import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In / Sign Up')),
      body: Center(
        child: Text('Authenticate to showcase or explore art!',
            style: Theme.of(context).textTheme.titleLarge),
      ),
    );
  }
}
