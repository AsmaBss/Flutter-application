class UserModel {
  int? id;
  String? email;
  String? password;
  String? firstname;
  String? lastname;

  UserModel({
    this.id,
    this.email,
    this.password,
    this.firstname,
    this.lastname,
  });

  @override
  String toString() {
    return 'User { id: $id, email: $email, '
        'password: $password, firstname: $firstname, '
        'lastname: $lastname}\n';
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      email: json['email'] as String,
      password: json['password'] as String,
      firstname: json['firstname'] as String,
      lastname: json['lastname'] as String,
    );
  }

  Map<String, dynamic> toJson(UserModel p) {
    return {
      'id': p.id,
      'email': p.email,
      'password': p.password,
      'firstname': p.firstname,
      'lastname': p.lastname,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(email: map['email'] ?? "")
      ..password = (map['password'] ?? "")
      ..firstname = (map['firstname'] ?? "")
      ..lastname = (map['lastname'] ?? "");
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'firstname': firstname,
      'lastname': lastname
    };
  }
}
