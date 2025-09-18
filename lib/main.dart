import 'package:flutter/material.dart';
import 'dart:async';
void main() {
  runApp(const DigitalPetApp());
}

class DigitalPetApp extends StatelessWidget {
  const DigitalPetApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DigitalPetHome(),
    );
  }
}

class DigitalPetHome extends StatefulWidget {
  @override
  _DigitalPetHomeState createState() => _DigitalPetHomeState();
}

class _DigitalPetHomeState extends State<DigitalPetHome> {
  String petName = "";
  int happinessLevel = 10;
  int hungerLevel = 10;
  int energyLevel = 50; // 0-100
  Timer? _hungerTimer;
  Timer? _winTimer;
  final TextEditingController _nameController = TextEditingController();
  bool _nameSet = false;
  bool _hasWon = false;
  bool _hasLost = false;
  @override
  void initState() {
    super.initState();
    _hungerTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      setState(() {
        hungerLevel += 5;
        if (hungerLevel > 100) hungerLevel = 100;
      });
    });
  }

  @override
  void dispose() {
    _hungerTimer?.cancel();
    _winTimer?.cancel();
    _nameController.dispose();
    super.dispose();
  }

  void _checkWinCondition() {
    if (_hasWon || _hasLost) return;
    // Win condition
    if (happinessLevel > 80) {
      if (_winTimer == null) {
        _winTimer = Timer(const Duration(seconds: 10), () {
          setState(() {
            _hasWon = true;
          });
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: const Text('You Win!'),
              content: const Text('Your pet has been happy for 3 minutes!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        });
      }
    } else {
      _winTimer?.cancel();
      _winTimer = null;
    }
    // Loss condition
    if (hungerLevel >= 100 && happinessLevel <= 10 && !_hasLost) {
      setState(() {
        _hasLost = true;
      });
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Game Over'),
          content: const Text('Your pet became too hungry and unhappy.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  String get petMoodText {
    if (happinessLevel > 70) {
      return "Happy";
    } else if (happinessLevel >= 30) {
      return "Neutral";
    } else {
      return "Unhappy";
    }
  }

  String get petMoodEmoji {
    if (happinessLevel > 70) {
      return "😊";
    } else if (happinessLevel >= 30) {
      return "😐";
    } else {
      return "😢";
    }
  }

  Color get petColor {
    if (happinessLevel > 70) {
      return Colors.green;
    } else if (happinessLevel >= 30) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

  void _playWithPet() {
    if (_hasWon || _hasLost) return;
    setState(() {
      happinessLevel += 10;
      _updateHunger();
      _checkWinCondition();
    });
  }

  void _feedPet() {
    if (_hasWon || _hasLost) return;
    setState(() {
      hungerLevel -= 10;
      _updateHappiness();
      _checkWinCondition();
    });
  }

  void _updateHappiness() {
    happinessLevel += 10;
    _checkWinCondition();
  }

  void _updateHunger() {
    if (_hasWon || _hasLost) return;
    setState(() {
      hungerLevel += 5;
      if (hungerLevel > 100) {
        hungerLevel = 100;
        happinessLevel -= 20;
      }
      _checkWinCondition();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_hasWon) {
      // Optionally, you can show a special win screen here
    }
    if (_hasWon) {
      // Optionally, you can show a special win screen here
    }
    if (_hasLost) {
      // Optionally, you can show a special loss screen here
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Pet'),
      ),
      body: Center(
        child: !_nameSet
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Name your pet:',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  const SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Pet Name',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      if (_nameController.text.trim().isNotEmpty) {
                        setState(() {
                          petName = _nameController.text.trim();
                          _nameSet = true;
                        });
                      }
                    },
                    child: const Text('Confirm Name'),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Pet visual representation with dynamic color and mood indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipOval(
                        child: Image.asset(
                          'assets/panda.png',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            petMoodText,
                            style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            petMoodEmoji,
                            style: const TextStyle(fontSize: 32.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Name: $petName',
                    style: const TextStyle(fontSize: 20.0),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Happiness Level: $happinessLevel',
                    style: const TextStyle(fontSize: 20.0),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Hunger Level: $hungerLevel',
                    style: const TextStyle(fontSize: 20.0),
                  ),
                  const SizedBox(height: 32.0),
                  ElevatedButton(
                    onPressed: _playWithPet,
                    child: const Text('Play with Your Pet'),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _feedPet,
                    child: const Text('Feed Your Pet'),
                  ),
                const SizedBox(height: 32.0),
                // Energy Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Energy',
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8.0),
                      LinearProgressIndicator(
                        value: energyLevel / 100.0,
                        minHeight: 16.0,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    ],
                  ),
                ),
                ],
              ),
      ),
    );
  }
}
