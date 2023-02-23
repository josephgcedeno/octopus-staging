// ignore_for_file: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

part 'dsr_request.g.dart';

@JsonSerializable()
class Task {
  Task({
    required this.text,
    required this.projectTagId,
  });

  factory Task.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$TaskFromJson(json);

  final String text;
  @JsonKey(name: 'project_tag_id')
  final String projectTagId;
  Map<String, dynamic> toJson() => _$TaskToJson(this);
}
