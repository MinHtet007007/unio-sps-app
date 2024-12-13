import 'package:sps/models/remote_township.dart';

class AuthUser {
  String name;
  String email;
  List<Township>? townships;
  int? projectId;
  String? project;
  String? tokenType;
  String? accessToken;
  int? expiresIn;

  AuthUser({
    required this.name,
    required this.email,
    this.townships,
    this.projectId,
    this.project,
    this.tokenType,
    this.accessToken,
    this.expiresIn,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      townships: (json['townships'] as List<dynamic>?)
              ?.map((e) => Township.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      projectId: json['project']?['id'] ?? 0,
      project: json['project']?['name'] ?? '',
      tokenType: json['token_type'] ?? '',
      accessToken: json['access_token'] ?? '',
      expiresIn: json['expires_in'] ?? 0,
    );
  }
}
