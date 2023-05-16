import 'package:json_annotation/json_annotation.dart';

part 'notice.g.dart';

/// 공지 모델 클래스
@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Notice {
  /// 공지 제목
  final String title;

  /// 공지가 올라간 날짜
  final DateTime datetime;

  /// index는 notice를 구분할때 쓰는 위한 별도의 값이 있다면 적는 란이다. index가 클 수록 최근의 공지로 판단.\
  /// 안적을 시 기본적으로 시간을 기준으로 구분한다. (즉 업로드 시간이 같다면 같은 공지로 판단)
  const Notice(this.title, this.datetime);

  @override
  int get hashCode => datetime.millisecondsSinceEpoch;

  // json serializaion
  factory Notice.fromJson(Map<String, dynamic> json) => _$NoticeFromJson(json);
  Map<String, dynamic> toJson() => _$NoticeToJson(this);

  @override
  bool operator ==(Object other) =>
      other is Notice &&
      other.title == title &&
      other.datetime.isAtSameMomentAs(datetime);
}

/// 공지 원본 사이트 정보를 담고 있는 모델 클래스
@JsonSerializable(fieldRename: FieldRename.snake)
class Origin {
  /// 사이트 이름
  final String name;

  /// 사이트 설명
  final String? description;

  /// 사이트 기본 uri (url 아님), 공지 더보기 시 접속되는 경로
  final String baseUri;

  /// 최종적으로 정보를 얻어오는 Endpoint의 url, Origin마다 고유해야 함
  final String endpointUrl;

  const Origin(this.name, this.description, this.baseUri, this.endpointUrl);

  // json serializaion
  factory Origin.fromJson(Map<String, dynamic> json) => _$OriginFromJson(json);
  Map<String, dynamic> toJson() => _$OriginToJson(this);
}
