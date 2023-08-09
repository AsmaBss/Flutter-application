import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application/src/screens/login.dart';
import 'package:flutter_application/src/sqlite/database-helper.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  //WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await DatabaseHelper().initDB();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maps',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Login(),
      debugShowCheckedModeBanner: false,
    );
  }
}
