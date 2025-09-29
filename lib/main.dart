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

  void setHappy() {
    _currentMood = 'happy';
    _backgroundColor = const Color.fromARGB(255, 250, 236, 110);
    notifyListeners();
    moodCounts['happy'] = (moodCounts['happy'] ?? 0) + 1;
  }

  void setSad() {
    _currentMood = 'sad';
    _backgroundColor = const Color.fromARGB(255, 68, 26, 175);
    moodCounts['sad'] = (moodCounts['sad'] ?? 0) + 1;
    notifyListeners();
  }

  void setExcited() {
    _currentMood = 'excited';
    _backgroundColor = const Color.fromARGB(255, 255, 91, 91);
    moodCounts['excited'] = (moodCounts['excited'] ?? 0) + 1;
    notifyListeners();
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
            SizedBox(height: 30),
            MoodDisplay(),
            SizedBox(height: 50),
            MoodButtons(),
            SizedBox(height: 10),
            MoodCounts(),
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
          width: 400,
          height:400,
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