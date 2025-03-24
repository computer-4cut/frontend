import 'package:flutter/material.dart';

class SelectPicturePage extends StatelessWidget {
  const SelectPicturePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Picture')),
      body: Center(
        child: Text('Select a picture from the gallery or take a new one.'),
      ),
    );
  }
}
