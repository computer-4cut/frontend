import 'package:flutter/material.dart';
import 'package:commit4cut/pages/start_page.dart';
import 'package:commit4cut/pages/select_picture.dart';
import 'package:commit4cut/pages/loading.dart';
import 'package:commit4cut/pages/camera.dart';
import 'package:commit4cut/pages/camera_test.dart';

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
        '/camera': (context) => const CameraPage(),
        '/camera_test': (context) => const CameraTestPage(),
      },
    );
  }
}
