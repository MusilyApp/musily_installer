import 'package:flutter/material.dart';
import 'package:musily_installer/app/widgets/musily_logo.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MusilyLogo(),
          Text(
            'Welcome to Musily',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'This wizard will guide you through the installation of Musily on your system.',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
