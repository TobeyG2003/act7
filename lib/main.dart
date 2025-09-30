import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => MoodModel(),
      child: MyApp(),
    ),
  );
}

// Mood Model - The "Brain" of our app
class MoodModel with ChangeNotifier {
  String _currentMood = 'happy';
  String get currentMood => _currentMood;
  Color _backgroundColor = Colors.yellow;
  Color get backgroundColor => _backgroundColor;
  Map<String, int> moodCounts = {
    'happy': 0,
    'sad': 0,
    'excited': 0,
  };
  List<String> moodHistory = [];

  void setHappy() {
    _currentMood = 'happy';
    _backgroundColor = const Color.fromARGB(255, 250, 236, 110);
    moodCounts['happy'] = (moodCounts['happy'] ?? 0) + 1;
    moodHistory.add('happy');
    if (moodHistory.length > 3) {
        moodHistory.removeAt(0);
      }
    notifyListeners();

  }

  void setSad() {
    _currentMood = 'sad';
    _backgroundColor = const Color.fromARGB(255, 68, 26, 175);
    moodCounts['sad'] = (moodCounts['sad'] ?? 0) + 1;
    moodHistory.add('sad');
    if (moodHistory.length > 3) {
        moodHistory.removeAt(0);
      }
    notifyListeners();
  }

  void setExcited() {
    _currentMood = 'excited';
    _backgroundColor = const Color.fromARGB(255, 255, 91, 91);
    moodCounts['excited'] = (moodCounts['excited'] ?? 0) + 1;
    moodHistory.add('excited');
    if (moodHistory.length > 3) {
        moodHistory.removeAt(0);
    }
    notifyListeners();
  }

  void setRandomMood() {
    int random = Random().nextInt(3);
    if (random == 0) {
      setHappy();
    } else if (random == 1) {
      setSad();
    } else {
      setExcited();
    }
  }
}

// Main App Widget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mood Toggle Challenge',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

// Home Page
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.watch<MoodModel>().backgroundColor,
      appBar: AppBar(title: Text('Mood Toggle Challenge')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('How are you feeling?', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            MoodDisplay(),
            SizedBox(height: 40),
            MoodButtons(),
            SizedBox(height: 10),
            MoodCounts(),
            SizedBox(height: 20),
            MoodHistory(),
          ],
        ),
      ),
    );
  }
}

// Widget that displays the current mood
class MoodDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MoodModel>(
      builder: (context, moodModel, child) {
        return Image.asset(
          'assets/${moodModel.currentMood}.jpg',
          width: 250,
          height:250,
          fit: BoxFit.cover,
        );
      },
    );
  }
}

// Widget with buttons to change the mood
class MoodButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            Provider.of<MoodModel>(context, listen: false).setHappy();
          },
          child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/happy.jpg',
                  width: 24,
                  height: 24,
                ),
                SizedBox(width: 8),
                Text('Happy'),
              ],
            ),
        ),
        ElevatedButton(
          onPressed: () {
            Provider.of<MoodModel>(context, listen: false).setSad();
          },
          child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/sad.jpg',
                  width: 24,
                  height: 24,
                ),
                SizedBox(width: 8),
                Text('Sad'),
              ],
            ),
        ),
        ElevatedButton(
          onPressed: () {
            Provider.of<MoodModel>(context, listen: false).setExcited();
          },
          child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/excited.jpg',
                  width: 24,
                  height: 24,
                ),
                SizedBox(width: 8),
                Text('Excited'),
              ],
            ),
        ),
        ElevatedButton(
          onPressed: () {
            Provider.of<MoodModel>(context, listen: false).setRandomMood();
          },
          style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple, // Background color of the button
          foregroundColor: const Color.fromARGB(255, 174, 255, 0), // Text/icon color
          shadowColor: const Color.fromARGB(255, 0, 255, 68),
          ),
          child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/surprised.jpg',
                  width: 24,
                  height: 24,
                ),
                SizedBox(width: 8),
                Text('Surpise!'),
              ],
            ),
        ),
      ],
    );
  }
}
class MoodCounts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MoodModel>(
      builder: (context, moodModel, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Happy: ${moodModel.moodCounts['happy']}', style: TextStyle(fontSize: 20)),
            SizedBox(width: 50),
            Text('Sad: ${moodModel.moodCounts['sad']}', style: TextStyle(fontSize: 20)),
            SizedBox(width: 50),
            Text('Excited: ${moodModel.moodCounts['excited']}', style: TextStyle(fontSize: 20)),
          ],
        );
      },
    );
  }
}
class MoodHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MoodModel>(
      builder: (context, moodModel, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('History:', style: TextStyle(fontSize: 20)),
            SizedBox(width: 15),
            if (moodModel.moodHistory.isEmpty)
              Text('No moods recorded yet.', style: TextStyle(fontSize: 15)),
            ...moodModel.moodHistory.reversed.map((mood) =>
              Text(mood, style: TextStyle(fontSize: 15)),
            ),
          ],
        );
      },
    );
  }
}