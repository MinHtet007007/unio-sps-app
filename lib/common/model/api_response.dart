class ApiResponse<T> {
  final String status;
  final T data;

  ApiResponse({
    required this.status,
    required this.data,
  });

  factory ApiResponse.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) create) {
    return ApiResponse(
      status: json['status'],
      data: create(json['data']),
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    return {
      'status': status,
      'data': toJsonT(data),
    };
  }
}
