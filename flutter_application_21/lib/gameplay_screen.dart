import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'congratulations_screen.dart';
import 'failure_screen.dart';

class GameplayScreen extends StatefulWidget {
  final int level;

  GameplayScreen({required this.level});

  @override
  _GameplayScreenState createState() => _GameplayScreenState();
}

class _GameplayScreenState extends State<GameplayScreen> {
  late int tapsRequired;
  late int timeLimit;
  int taps = 0;
  late Timer timer;
  late int timeLeft;

  @override
  void initState() {
    super.initState();
    tapsRequired = 50 + (widget.level - 1) * 10;
    timeLimit = 30 - (widget.level - 1);
    timeLeft = timeLimit;

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        setState(() {
          timeLeft--;
        });
      } else {
        timer.cancel();
        showFailureDialog();
      }
    });
  }

  Future<void> _markLevelAsCompleted() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('level_${widget.level}', true);
  }

  void showFailureDialog() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => FailureScreen(level: widget.level),
      ),
    );
  }

  void showSuccessDialog() {
    int stars;
    if (timeLeft >= timeLimit * 0.75) {
      stars = 3;
    } else if (timeLeft >= timeLimit * 0.5) {
      stars = 2;
    } else {
      stars = 1;
    }

    _markLevelAsCompleted();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CongratulationsScreen(stars: stars, level: widget.level),
      ),
    );
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('image/download1.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF4B0082).withOpacity(0.7),
                    Color(0xFF0000FF).withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  formatTime(timeLeft),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      taps++;
                      if (taps >= tapsRequired) {
                        timer.cancel();
                        showSuccessDialog();
                      }
                    });
                  },
                  child: Icon(
                    Icons.circle,
                    size: 150,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Taps: $taps',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Tap $tapsRequired Times',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
