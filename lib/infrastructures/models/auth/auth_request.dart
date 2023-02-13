// ignore_for_file: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

part 'auth_request.g.dart';

@JsonSerializable()
class AuthLoginRequest {
  AuthLoginRequest({
    required this.username,
    required this.password,
  });

  factory AuthLoginRequest.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$AuthLoginRequestFromJson(json);

  final String username;
  final String password;
}

@JsonSerializable()
class AuthRegisterRequest {
  AuthRegisterRequest({
    required this.email,
    required this.password,
    required this.position,
    this.isAdmin,
    this.photo,
  });

  factory AuthRegisterRequest.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$AuthRegisterRequestFromJson(json);

  final String email;
  final String password;
  final String? photo;
  final String position;
  final bool? isAdmin;
}
