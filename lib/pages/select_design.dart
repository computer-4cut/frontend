import 'package:flutter/material.dart';

class SelectDesignPage extends StatelessWidget {
  const SelectDesignPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Design')),
      body: Center(child: Text('Select a design from the options below.')),
    );
  }
}
