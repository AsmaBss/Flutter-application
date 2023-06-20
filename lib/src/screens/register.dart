import 'package:flutter/material.dart';
import 'package:flutter_application/src/models/user-model.dart';
import 'package:flutter_application/src/repositories/auth-repository.dart';
import 'package:flutter_application/src/screens/login.dart';
import 'package:flutter_application/src/widget/register-form-widget.dart';

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();

  @override
  void dispose() {
    username.dispose();
    password.dispose();
    firstname.dispose();
    lastname.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: SizedBox(
                    width: 400,
                    height: 300,
                    child: Image.asset('assets/images/register.png')),
              ),
              RegisterFormWidget(
                formKey: _formKey,
                username: username,
                password: password,
                firstname: firstname,
                lastname: lastname,
              ),
              Padding(
                padding: EdgeInsets.all(40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => Login()));
                        },
                        child: Text("Se connecter")),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await AuthRepository().register(
                              UserModel(
                                  firstname: firstname.text,
                                  lastname: lastname.text,
                                  email: username.text,
                                  password: password.text,
                                  roles: null),
                              context);
                        }
                      },
                      child: Text("Register"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
