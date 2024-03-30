import 'package:flutter/material.dart';
import 'package:ui_tests/audio_recordings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'dart:async';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: const Scaffold(body: Recorder()),
    ),
  );
}


