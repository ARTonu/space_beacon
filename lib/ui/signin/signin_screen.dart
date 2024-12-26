import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../gen/assets.gen.dart';

class SigninScreen extends StatelessWidget {
  const SigninScreen({super.key});

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Space Beacon",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              Assets.anim.animSignin,
              repeat: true,
              height: 200,
            ),
            const Padding(
              padding: EdgeInsets.only(
                top: 20,
              ),
              child: Text(
                "Signing in...",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
