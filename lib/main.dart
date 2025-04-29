import 'package:flutter/material.dart';
import 'package:commit4cut/pages/start_page.dart';
import 'package:commit4cut/pages/select_picture.dart';
import 'package:commit4cut/pages/loading.dart';

void main() {
  runApp(const Commit4cut());
}

class Commit4cut extends StatelessWidget {
  const Commit4cut({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '컴공네컷',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const StartPage(title: '컴공네컷'),
        '/select_picture': (context) => const SelectPicturePage(),
        '/loading': (context) => const LoadingPage(),
      },
    );
  }
}
