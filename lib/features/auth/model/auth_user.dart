
class AuthUser {
  String name;
  int? id;
  int? townshipId;
  int? projectId;
  String? township;
  String? project;
  String? tokenType;
  String? accessToken;
  int? expiresIn;

  AuthUser({
    required this.name,
     this.id,
    this.townshipId,
    this.projectId,
    this.township,
    this.project,
    this.tokenType,
    this.accessToken,
    this.expiresIn,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      name: json['name'] ?? '',
      id: json['id'] ?? 0,
      townshipId: json['township'] != null ? json['township']['id'] : 0,
      projectId: json['project'] != null ? json['project']['id'] : 0,
      project: json['project'] != null ? json['project']['name'] : '',
      township: json['township'] != null ? json['township']['name'] : '',
      tokenType: json['token_type'] ?? '',
      accessToken: json['access_token'] ?? '',
      expiresIn: json['expires_in'] ?? 0,
    );
  }

}
