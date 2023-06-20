import 'package:flutter/material.dart';

class RegisterFormWidget extends StatelessWidget {
  final Key? formKey;
  final TextEditingController? username, password, firstname, lastname;

  RegisterFormWidget(
      {this.formKey,
      this.username,
      this.password,
      this.firstname,
      this.lastname});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 15.0, right: 40.0, left: 40.0),
            child: TextFormField(
              controller: firstname,
              keyboardType: TextInputType.text,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                labelText: "Prénom",
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.green),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Veuillez saisir votre prénom';
                }
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 15.0, right: 40.0, left: 40.0),
            child: TextFormField(
              controller: lastname,
              keyboardType: TextInputType.text,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                labelText: "Nom",
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.green),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Veuillez saisir votre nom';
                }
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 15.0, right: 40.0, left: 40.0),
            child: TextFormField(
              controller: username,
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                labelText: "Email",
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.green),
                ),
              ),
              validator: (value) {
                const pattern =
                    r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
                    r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
                    r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
                    r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
                    r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
                    r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
                    r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
                final regex = RegExp(pattern);
                if (value!.isEmpty) {
                  return 'Veuillez saisir l\'adresse e-mail';
                }
                if (value!.isNotEmpty && !regex.hasMatch(value)) {
                  return 'Entrez une adresse mail valide';
                }
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 15.0, right: 40.0, left: 40.0),
            child: TextFormField(
              controller: password,
              keyboardType: TextInputType.visiblePassword,
              textAlign: TextAlign.center,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Mot de Passe",
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.green),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Veuillez saisir le mot de passe';
                }
                if (value!.isNotEmpty && value.length < 6) {
                  return 'Doit contenir plus de 5 caractères';
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
