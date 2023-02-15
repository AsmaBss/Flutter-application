import 'package:flutter/material.dart';
import 'google-maps.dart';

void main() {
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
