import 'package:flutter/material.dart';
import 'gameplay_screen.dart';
import 'training_screen.dart';

class CongratulationsScreen extends StatelessWidget {
  final int stars;
  final int score;
  final int highestScore;
  final bool isTrainingMode;
  final int level;

  CongratulationsScreen({
    this.stars = 0,
    this.score = 0,
    this.highestScore = 0,
    this.isTrainingMode = false,
    this.level = 0,
  });

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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (!isTrainingMode)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return Icon(
                      Icons.star,
                      color: index < stars ? Colors.yellow : Colors.grey,
                      size: 50,
                    );
                  }),
                ),
              SizedBox(height: 20),
              Text(
                isTrainingMode ? 'Your Score' : 'Congratulations',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isTrainingMode) ...[
                SizedBox(height: 20),
                Text(
                  'Score: $score',
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
                          builder: (context) => isTrainingMode
                              ? TrainingScreen()
                              : GameplayScreen(level: level + 1),
                        ),
                      );
                    },
                    child: Text('Next'),
                  ),
                ],
              ),
              if (isTrainingMode)
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TrainingScreen(),
                      ),
                    );
                  },
                  child: Text('Try Again'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
