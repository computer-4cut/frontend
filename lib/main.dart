import 'package:flutter/material.dart';
import 'package:commit4cut/pages/start_page.dart';

void main() {
  runApp(const Commit4cut());
}

class Commit4cut extends StatelessWidget {
  const Commit4cut({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '컴공네컷',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const StartPage(title: '컴공네컷'),
    );
  }
}
