import 'package:sps/local_database/entity/user_township_entity.dart';

class User {
  String name;
  int? id;
  List<UserTownshipEntity>? townships;
  User({required this.name, this.id, required this.townships});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] ?? '',
      id: json['id'] ?? 0,
      townships: json['townships'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    data['townships'] = townships;
    return data;
  }
}
