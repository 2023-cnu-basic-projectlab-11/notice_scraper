import 'package:json_annotation/json_annotation.dart';

part 'notice.g.dart';

/// 공지 모델 클래스
@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Notice {
  /// 공지 제목
  final String title;

  /// 공지가 올라간 날짜
  final DateTime datetime;

  /// 공지가 올라간 사이트
  final Origin origin;

  const Notice(this.title, this.datetime, this.origin);

  // json serializaion
  factory Notice.fromJson(Map<String, dynamic> json) => _$NoticeFromJson(json);
  Map<String, dynamic> toJson() => _$NoticeToJson(this);
}

/// 공지 원본 사이트 정보를 담고 있는 모델 클래스
@JsonSerializable(fieldRename: FieldRename.snake)
class Origin {
  /// 사이트 이름
  final String name;

  /// 사이트 설명
  final String description;

  /// 사이트 기본 base uri
  final String baseUri;

  const Origin(this.name, this.description, this.baseUri);

  // json serializaion
  factory Origin.fromJson(Map<String, dynamic> json) => _$OriginFromJson(json);
  Map<String, dynamic> toJson() => _$OriginToJson(this);
}
