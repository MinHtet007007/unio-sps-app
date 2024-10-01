class AuthUser {
  String name;
  int? id;
  String code;
  String township;
  String? tokenType;
  String? accessToken;
  int? expiresIn;

  AuthUser({
    required this.name,
     this.id,
    required this.code,
    required this.township,
    this.tokenType,
    this.accessToken,
    this.expiresIn,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      name: json['name'] ?? '',
      id: json['id'] ?? 0,
      code: json['code'] ?? '',
      township: json['township'] ?? '',
      tokenType: json['token_type'] ?? '',
      accessToken: json['access_token'] ?? '',
      expiresIn: json['expires_in'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    data['code'] = code;
    data['township'] = township;
    data['token_type'] = tokenType;
    data['access_token'] = accessToken;
    data['expires_in'] = expiresIn;
    return data;
  }
}
