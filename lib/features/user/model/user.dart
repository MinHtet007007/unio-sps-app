class User {
  String name;
  int id;
  String email;
  String township;
  User({
    required this.name,
    required this.id,
    required this.email,
    required this.township,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] ?? '',
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      township: json['township'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    data['email'] = email;
    data['township'] = township;
    return data;
  }
}
