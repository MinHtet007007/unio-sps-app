// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_township.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Township _$TownshipFromJson(Map<String, dynamic> json) => Township(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      abbreviation: json['abbreviation'] as String,
    );

Map<String, dynamic> _$TownshipToJson(Township instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'abbreviation': instance.abbreviation,
    };
