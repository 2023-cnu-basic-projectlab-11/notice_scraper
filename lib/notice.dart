import 'package:json_annotation/json_annotation.dart';

part 'notice.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Notice {
  final String title;
  final String date;
  final String body;
  final Origin origin;

  Notice(this.title, this.date, this.body, this.origin);

  // json serializaion
  factory Notice.fromJson(Map<String, dynamic> json) => _$NoticeFromJson(json);
  Map<String, dynamic> toJson() => _$NoticeToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Origin {
  final String name;
  final String description;
  final String baseUri;

  Origin(this.name, this.description, this.baseUri);

  factory Origin.fromJson(Map<String, dynamic> json) => _$OriginFromJson(json);
  Map<String, dynamic> toJson() => _$OriginToJson(this);
}
