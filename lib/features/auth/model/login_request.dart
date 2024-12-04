class LoginRequest {
  final String code;
  final String password;

  LoginRequest({required this.code, required this.password});

  Map<String, dynamic> toJson() => {
        'code': code,
        'password': password,
      };
}
