// ignore_for_file: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

part 'dsr_request.g.dart';

@JsonSerializable()
class DSRWorkTrack {
  final String text;
  @JsonKey(name: 'project_tag_id')
  final String projectTagId;

  DSRWorkTrack({
    required this.text,
    required this.projectTagId,
  });
  factory DSRWorkTrack.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$DSRWorkTrackFromJson(json);
  Map<String, dynamic> toJson() => _$DSRWorkTrackToJson(this);
}
