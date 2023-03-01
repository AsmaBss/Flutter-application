import 'package:flutter/material.dart';
import 'package:flutter_application/src/database/database-helper.dart';
import 'package:flutter_application/test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'src/screens/maps.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  await DatabaseHelper().initDB();
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
      home: const Maps(), //Test(),
      debugShowCheckedModeBanner: false,
    );
  }
}
