import 'package:flutter/material.dart';
import 'camera.dart';

class SelectDesignPage extends StatefulWidget {
  const SelectDesignPage({super.key});

  @override
  SelectDesignPageState createState() => SelectDesignPageState();
}

// 페이지 불러오자마자 바로 다음 페이지로 리다이렉트
// (임시)
class SelectDesignPageState extends State<SelectDesignPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CameraPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Design')),
      body: Center(child: Text('Select a design from the options below.')),
    );
  }
}
