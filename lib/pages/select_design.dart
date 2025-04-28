import 'package:flutter/material.dart';

class SelectDesignPage extends StatelessWidget {
  const SelectDesignPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Design')),
      body: Stack(
        children: [
          Center(child: Text('Select a design from the options below.')),
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/select_picture');
              },
              child: const Icon(Icons.arrow_forward),
            ),
          ),
        ],
      ),
    );
  }
}
