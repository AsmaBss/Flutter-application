import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  String? value = '';

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    /*SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      value = prefs.getString('key_test');
    });*/
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Text(
            value ?? 'No data in sharedPreferences',
            style: TextStyle(fontSize: 30, color: Colors.white),
          ),
          SizedBox(
            height: 50,
          ),
          ElevatedButton(
              onPressed: () async {
                String url = '${dotenv.env['BASE_URL']}Test/add-test';
                var response = await http.post(
                  Uri.parse(url),
                  headers: {
                    'Content-Type': 'application/json',
                  },
                  body: jsonEncode({
                    'testcol': 'flutter',
                  }),
                );
                print(response.statusCode);
                print(response.body);
              },
              child: Text('insert data to db')),
          ElevatedButton(
            onPressed: () async {
              final connectivityResult =
                  await (Connectivity().checkConnectivity());
              if (connectivityResult == ConnectivityResult.mobile) {
                print("Mobile network");
              } else if (connectivityResult == ConnectivityResult.wifi) {
                print("Wifi network");
              } else {
                print("No network");
              }
            },
            child: Text("load data"),
          ),
          ElevatedButton(
            onPressed: () async {
              /*SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString('key_test', 'MyValue');*/
            },
            child: Text("save data"),
          ),
          ElevatedButton(
            onPressed: () async {
              /*SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove('key_test');*/
            },
            child: Text("clean data"),
          )
        ],
      ),
    );
  }
}
