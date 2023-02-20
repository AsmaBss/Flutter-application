import 'package:flutter/material.dart';
import 'package:flutter_application/test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'src/screens/google-maps.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Maps',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const HomePage(), //Test(),
      debugShowCheckedModeBanner: false,
    );
  }
}
