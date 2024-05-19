import 'package:flutter/material.dart';
import 'gameplay_screen.dart';

class FailureScreen extends StatelessWidget {
  final int level;

  FailureScreen({required this.level});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4B0082),
              Color(0xFF0000FF),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Icon(
                  Icons.star_border,
                  color: Colors.white,
                  size: 50,
                );
              }),
            ),
            SizedBox(height: 20),
            Text(
              'You Failed',
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                  },
                  child: Text('Menu'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GameplayScreen(level: level),
                      ),
                    );
                  },
                  child: Text('Try Again'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
