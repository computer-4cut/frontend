import 'package:flutter/material.dart';
import 'package:commit4cut/style/font.dart';
import 'package:commit4cut/util.dart';
import 'package:commit4cut/pages/select_design.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key, required this.title});

  final String title;

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 200,
                    right: 200,
                    top: 100,
                    bottom: 160,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(16.0),
                          crossAxisCount: 2,
                          crossAxisSpacing: 16.0,
                          mainAxisSpacing: 16.0,
                          childAspectRatio: 1,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: 10,
                                ),
                              ),
                              child: Image.asset(
                                'assets/images/1.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: 10,
                                ),
                              ),
                              child: Image.asset(
                                'assets/images/2.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: 10,
                                ),
                              ),
                              child: Image.asset(
                                'assets/images/3.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: 10,
                                ),
                              ),
                              child: Image.asset(
                                'assets/images/4.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GradientText(
                        '컴공네컷',
                        style: TextStyle(
                          fontSize: 100,
                          fontWeight: FontWeight.bold,
                          fontFamily: CustomFontFamily.hsyuji,
                        ),
                        gradient: LinearGradient(
                          colors: [Color(0xFF617EF1), Color(0xFF7D49A8)],
                        ),
                      ),
                      SizedBox(height: 160),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          shadowColor: Colors.black.withValues(alpha: 1),
                          elevation: 10,
                          backgroundColor: Colors.transparent,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SelectDesignPage(),
                            ),
                          );
                        },
                        clipBehavior: Clip.antiAlias,
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Color(0xFF617EF1), Color(0xFF7D49A8)],
                            ),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 1),
                                spreadRadius: 5,
                                blurRadius: 10,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            constraints: BoxConstraints(
                              maxWidth: 400,
                              maxHeight: 115,
                            ),
                            child: Text(
                              '시작하기',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 60,
                                fontFamily: CustomFontFamily.hsyuji,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
