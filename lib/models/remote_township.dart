import 'package:json_annotation/json_annotation.dart';

part 'remote_township.g.dart';

@JsonSerializable()
class Township {
  final int id;
  final String name;
  final String abbreviation;

  Township({
    required this.id,
    required this.name,
    required this.abbreviation,
  });

  factory Township.fromJson(Map<String, dynamic> json) {
    return Township(
      id: json['id'],
      name: json['name'],
      abbreviation: json['abbreviation'],
    );
  }
  Map<String, dynamic> toJson() => _$TownshipToJson(this);
}
