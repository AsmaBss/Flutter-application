import 'package:flutter/material.dart';
import 'package:flutter_application/src/api-services/SharedPreference.dart';
import 'package:flutter_application/src/models/TypeRoleEnum.dart';
import 'package:flutter_application/src/models/jwt-request.dart';
import 'package:flutter_application/src/models/jwt-response.dart';
import 'package:flutter_application/src/repositories/auth-repository.dart';
import 'package:flutter_application/src/screens/maps.dart';
import 'package:flutter_application/src/screens/register.dart';
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
                    child: Image.asset('assets/images/login.png')),
              ),
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
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => Register()));
                      },
                      child: Text("Register"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await AuthRepository()
                              .login(
                                  JwtRequest(
                                      username: username.text,
                                      password: password.text),
                                  context)
                              .then((value) {
                            value.user.roles?.forEach((role) {
                              if (role.type == TypeRoleEnum.SIMPLE_USER ||
                                  role.type == TypeRoleEnum.ADMIN) {
                                SharedPreference()
                                    .storeJwtToken(value.jwtToken);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) => Maps()));
                              } else if (role.type == TypeRoleEnum.SUPERVISOR) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text("Vous n'avez pas le droit !"),
                                ));
                              }
                            });
                          }).catchError((error) {});
                          /*response.user.roles?.forEach((role) {
                            if (role.type == TypeRoleEnum.SIMPLE_USER ||
                                role.type == TypeRoleEnum.ADMIN) {
                              SharedPreference()
                                  .storeJwtToken(response.jwtToken);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) => Maps()));
                            } else if (role.type == TypeRoleEnum.SUSERPISOR) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("Vous n'avez pas le droit !"),
                              ));
                            }
                          });*/
                        }
                      },
                      child: Text("Se connecter"),
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
