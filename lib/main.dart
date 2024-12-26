import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() => runApp(
      const GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: Home(),
      ),
    );

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hello Flutter")),
      body: const Center(
        child: Text("How are you today?"),
      ),
    );
  }
}
