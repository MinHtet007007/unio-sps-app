
import 'package:json_annotation/json_annotation.dart';

part 'remote_township.g.dart';

@JsonSerializable()
class Township {
  final int id;
  final String name;

  Township({
    required this.id,
    required this.name,
  });

  factory Township.fromJson(Map<String, dynamic> json) {
    return Township(
      id: json['id'],
      name: json['name'],
    );
  }
    Map<String, dynamic> toJson() => _$TownshipToJson(this);

}
