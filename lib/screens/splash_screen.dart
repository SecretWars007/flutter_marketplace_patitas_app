import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final String _text = 'Bienvenido a PATITAS';
  String _displayedText = '';
  int _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
      if (_index < _text.length) {
        setState(() {
          _displayedText += _text[_index];
          _index++;
        });
      } else {
        _timer?.cancel();
        Future.delayed(const Duration(seconds: 15), () {
          Navigator.pushReplacementNamed(
            // ignore: use_build_context_synchronously
            context,
            '/login',
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Center(
        child: Text(
          _displayedText,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
