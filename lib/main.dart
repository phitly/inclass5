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
  int happinessLevel = 50;
  int hungerLevel = 50;
  Timer? _hungerTimer;
  final TextEditingController _nameController = TextEditingController();
  bool _nameSet = false;
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
    _nameController.dispose();
    super.dispose();
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
    setState(() {
      happinessLevel += 10;
      _updateHunger();
    });
  }

  void _feedPet() {
    setState(() {
      hungerLevel -= 10;
      _updateHappiness();
    });
  }

  void _updateHappiness() {
    happinessLevel += 10;
  }

  void _updateHunger() {
    setState(() {
      hungerLevel += 5;
      if (hungerLevel > 100) {
        hungerLevel = 100;
        happinessLevel -= 20;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: petColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black, width: 2),
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
                ],
              ),
      ),
    );
  }
}
