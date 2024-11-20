import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

class GameTheoryBuzzer extends StatefulWidget {
  const GameTheoryBuzzer({Key? key}) : super(key: key);

  @override
  _GameTheoryBuzzerState createState() => _GameTheoryBuzzerState();
}

class _GameTheoryBuzzerState extends State<GameTheoryBuzzer> {
  late AudioPlayer player = AudioPlayer();
  bool isBuzzed = false;
  bool isPressed = false;

  @override
  void initState() {
    super.initState();

    // Initialize the audio player.
    player = AudioPlayer();
    player.setReleaseMode(ReleaseMode.stop);

    // Preload the sound.
    player.setSource(AssetSource('buzz.mp3'));
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  Future<void> _buzz() async {
    setState(() {
      isBuzzed = true;
    });

    // Play the buzzer sound.
    await player.resume();

    // Reset the button state after a short delay.
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isBuzzed = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'GAME THEORY',
          style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: size.width,),
          Text(
            'Press the Buzzer!',
            style: TextStyle(
              fontSize: size.width * 0.08,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: size.height * 0.1),
          GestureDetector(
            onTapDown: (_) {
              setState(() {
                isPressed = true;
              });
            },
            onTapUp: (_) async {
              setState(() {
                isPressed = false;
              });
              await _buzz();
            },
            onTapCancel: () {
              setState(() {
                isPressed = false;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeInOut,
              width: isPressed ? size.width * 0.55 : size.width * 0.6,
              height: isPressed ? size.width * 0.55 : size.width * 0.6,
              decoration: BoxDecoration(
                color: isBuzzed ? Colors.green : Colors.red,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: isPressed
                        ? Colors.black
                        : (isBuzzed ? Colors.greenAccent : Colors.redAccent),
                    offset: isPressed ? const Offset(4, 4) : const Offset(10, 10),
                    blurRadius: isPressed ? 10 : 20,
                    spreadRadius: isPressed ? 1 : 5,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  isBuzzed ? 'Buzzed!' : 'BUZZ',
                  style: TextStyle(
                    fontSize: size.width * 0.08,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: size.height * 0.1),
          const Text(
            'Game On!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
