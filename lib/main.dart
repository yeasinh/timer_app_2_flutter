import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Timer? timer;
  late AnimationController controller;

  bool _isPaused = true;
  bool _isModeButtonPressed = false;
  String _textMinute = "00";
  String _textSecond = "00";

  TimeMode _mode = TimeMode(minute: -1, second: -1, color: Colors.grey[800]);

  modeButtonPressed() {
    _isModeButtonPressed = true;
    _isPaused = true;
    _mode.minute < 10
        ? _textMinute = "0" + _mode.minute.toString()
        : _textMinute = _mode.minute.toString();
    _mode.second < 10
        ? _textSecond = "0" + _mode.second.toString()
        : _textSecond = _mode.second.toString();

    setState(() {});
  }

  workMode() {
    _mode = TimeMode(minute: 30, second: 0, color: Colors.green[600]);
    modeButtonPressed();
  }

  longBreak() {
    _mode = TimeMode(minute: 20, second: 0, color: Colors.red[600]);
    modeButtonPressed();
  }

  shortBreak() {
    _mode = TimeMode(minute: 5, second: 0, color: Colors.amber[400]);
    modeButtonPressed();
  }

  actionButtonPressed() {
    if (_mode.minute == -1) {
      return;
    }
    if (_isPaused) {
      _isPaused = false;
      _isModeButtonPressed = false;

      timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!_isModeButtonPressed) {
          setState(() {
            _mode.second -= 1;
            if (_mode.second < 0) {
              _mode.minute -= 1;
              _mode.second = 59;
            }
            _mode.minute < 10
                ? _textMinute = "0" + _mode.minute.toString()
                : _textMinute = _mode.minute.toString();
            _mode.second < 10
                ? _textSecond = "0" + _mode.second.toString()
                : _textSecond = _mode.second.toString();
          });

          if (_mode.minute < 0) {
            stopTimer();
          }
        } else {
          timer!.cancel();
        }
      });
    } else {
      _isPaused = true;
      timer!.cancel();
      setState(() {});
    }
  }

  stopTimer() async {
    timer!.cancel();
    setState(() {
      _mode.minute = -1;
      _mode.second = 0;
      _mode.color = Colors.grey[800];
      _isPaused = true;
    });

    // AudioPlayer audioPlayer = AudioPlayer();

    AudioCache audioCache = AudioCache();
    audioCache.load("song.mp3");
    audioCache.play("song.mp3");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text("Timer App"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[800],
      ),
      body: Column(
        children: [
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: workMode,
                  child: const Text(
                    "Work Time",
                    textAlign: TextAlign.center,
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green[600],
                    fixedSize: const Size(100.0, 50.0),
                  )),
              ElevatedButton(
                  onPressed: longBreak,
                  child: const Text(
                    "Long Break",
                    textAlign: TextAlign.center,
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red[600],
                    fixedSize: const Size(100.0, 50.0),
                  )),
              ElevatedButton(
                  onPressed: shortBreak,
                  child: const Text(
                    "Short Break",
                    textAlign: TextAlign.center,
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.amber[400],
                    fixedSize: const Size(100.0, 50.0),
                  )),
            ],
          ),
          const SizedBox(height: 180),
          Stack(alignment: Alignment.center, children: [
            Transform.scale(
              scale: 5,
              child: CircularProgressIndicator(
                value: (_mode.second/60),
                backgroundColor: _mode.color,
                color: Colors.black,
                strokeWidth: 2,
              ),
            ),
            _mode.minute != -1
                ? Text(
                    "$_textMinute : $_textSecond",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : const Text(
                    "Choose Time",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
          ]),
          const SizedBox(height: 200),
          FloatingActionButton(
              onPressed: actionButtonPressed,
              elevation: 2,
              hoverElevation: 8,
              child: _isPaused
                  ? const Icon(Icons.play_arrow)
                  : const Icon(Icons.pause)),
        ],
      ),
    );
  }
}

class TimeMode {
  int minute;
  int second;
  Color? color;

  TimeMode({required this.minute, required this.second, required this.color});
}
