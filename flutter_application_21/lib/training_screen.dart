import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'congratulations_screen.dart';

class TrainingScreen extends StatefulWidget {
  @override
  _TrainingScreenState createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  int taps = 0;
  int timeLeft = 20;
  late Timer timer;
  int highestScore = 0;

  @override
  void initState() {
    super.initState();
    loadHighestScore();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        setState(() {
          timeLeft--;
        });
      } else {
        timer.cancel();
        saveHighestScore();
        showResultsScreen();
      }
    });
  }

  Future<void> loadHighestScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      highestScore = prefs.getInt('highestScore') ?? 0;
    });
  }

  Future<void> saveHighestScore() async {
    if (taps > highestScore) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('highestScore', taps);
      setState(() {
        highestScore = taps;
      });
    }
  }

  void showResultsScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CongratulationsScreen(
          score: taps,
          highestScore: highestScore,
          isTrainingMode: true,
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes}:${remainingSeconds.toString().padLeft(2, '0')}';
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
                  'Highest Score: $highestScore',
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
