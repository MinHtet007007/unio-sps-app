class User {
  String name;
  int id;
  String code;
  String township;
  User({
    required this.name,
    required this.id,
    required this.code,
    required this.township,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] ?? '',
      id: json['id'] ?? 0,
      code: json['code'] ?? '',
      township: json['township'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    data['code'] = code;
    data['township'] = township;
    return data;
  }
}
