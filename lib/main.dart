import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:messapp/mainscreens/adminhome.dart';
import 'package:messapp/mainscreens/Welcome/welcome_screen.dart';
import 'package:messapp/mainscreens/SignUpSelectionScreem.dart';

import 'auth/login.dart';
import 'firebase_options.dart';
import 'mainscreens/userhome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const WelcomeScreen());
  }
}