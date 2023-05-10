import 'package:json_annotation/json_annotation.dart';

part 'notice.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Notice {
  final String title;
  final DateTime datetime;
  final Origin origin;

  const Notice(this.title, this.datetime, this.origin);

  // json serializaion
  factory Notice.fromJson(Map<String, dynamic> json) => _$NoticeFromJson(json);
  Map<String, dynamic> toJson() => _$NoticeToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Origin {
  final String id;
  final String name;
  final String description;
  final String baseUri;

  const Origin(this.id, this.name, this.description, this.baseUri);

  // json serializaion
  factory Origin.fromJson(Map<String, dynamic> json) => _$OriginFromJson(json);
  Map<String, dynamic> toJson() => _$OriginToJson(this);
}
