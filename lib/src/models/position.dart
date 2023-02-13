class Position {
  String? id, address, description, latitude, longitude;

  Position(
      {this.id, this.address, this.description, this.latitude, this.longitude});

  factory Position.fromJSon(Map<String, dynamic> json) {
    return Position(
        id: json["id"],
        address: json["address"],
        description: json["description"],
        latitude: json["latitude"],
        longitude: json["longitude"]);
  }
}
