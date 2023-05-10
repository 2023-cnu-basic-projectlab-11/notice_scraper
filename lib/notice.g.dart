// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notice _$NoticeFromJson(Map<String, dynamic> json) => Notice(
      json['title'] as String,
      DateTime.parse(json['date'] as String),
      json['body'] as String,
      Origin.fromJson(json['origin'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NoticeToJson(Notice instance) => <String, dynamic>{
      'title': instance.title,
      'date': instance.date.toIso8601String(),
      'body': instance.body,
      'origin': instance.origin.toJson(),
    };

Origin _$OriginFromJson(Map<String, dynamic> json) => Origin(
      json['name'] as String,
      json['description'] as String,
      json['base_uri'] as String,
    );

Map<String, dynamic> _$OriginToJson(Origin instance) => <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'base_uri': instance.baseUri,
    };
