import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'gameplay_screen.dart';

class LevelsScreen extends StatefulWidget {
  @override
  _LevelsScreenState createState() => _LevelsScreenState();
}

class _LevelsScreenState extends State<LevelsScreen> {
  List<bool> _levelCompletionStatus = [true, false, false, false, false, false];

  @override
  void initState() {
    super.initState();
    _loadLevelCompletionStatus();
  }

  Future<void> _loadLevelCompletionStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      for (int i = 1; i <= 6; i++) {
        _levelCompletionStatus[i - 1] = prefs.getBool('level_$i') ?? false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Levels',
          style: TextStyle(
            fontFamily: 'CustomFont',
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            itemCount: 6,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
            ),
            itemBuilder: (context, index) {
              bool isLevelAccessible = index == 0 || _levelCompletionStatus[index - 1];
              return GestureDetector(
                onTap: isLevelAccessible
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GameplayScreen(level: index + 1),
                          ),
                        );
                      }
                    : null,
                child: Container(
                  decoration: BoxDecoration(
                    color: isLevelAccessible ? Colors.blueAccent : Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'Level ${index + 1}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black45,
                            offset: Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
