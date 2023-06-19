import 'package:flutter/material.dart';
import 'package:flutter_application/src/api-services/SharedPreference.dart';
import 'package:flutter_application/src/models/jwt-request.dart';
import 'package:flutter_application/src/models/jwt-response.dart';
import 'package:flutter_application/src/repositories/auth-repository.dart';
import 'package:flutter_application/src/screens/maps.dart';
import 'package:flutter_application/src/widget/login-form-widget.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    username.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(30.0),
        child: Column(
          children: [
            LoginFormWidget(
              formKey: _formKey,
              username: username,
              password: password,
            ),
            Padding(
              padding: EdgeInsets.all(40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      print("password = ${password.text}");
                      print("username = ${username.text}");
                      //if (_formKey.currentState!.validate()) {
                      JwtResponse response = await AuthRepository()
                          .login(
                              JwtRequest(
                                  username: username.text,
                                  password: password.text),
                              context)
                          .catchError((error) {});
                      print(
                          " --------------------------------> ${response.jwtToken}");
                      print(
                          " --------------------------------> ${response.user}");
                      await SharedPreference()
                          .storeJwtToken(response.jwtToken)
                          .then((value) => print("jwtToken stored"));
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => Maps()));

                      //}
                    },
                    child: Text("Enregistrer"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
