import 'package:projectile/src/core/request_models/request.dart';
import 'package:projectile/src/core/result_models/result.dart';

/// {@template success}
///
/// {@endtemplate}
class SuccessResult extends ProjectileResult {
  SuccessResult._({
    required this.headers,
    required this.data,
    required this.originalRequest,
    this.statusCode,
  });

  factory SuccessResult.def({
    required dynamic data,
    required Map<String, dynamic> headers,
    required ProjectileRequest originalRequest,
    int? statusCode,
    // this.originalData,
  }) =>
      SuccessResult._(
        headers: headers,
        data: data,
        originalRequest: originalRequest,
        statusCode: statusCode,
      );

  final dynamic data;
  final int? statusCode;
  final Map<String, dynamic> headers;
  final ProjectileRequest originalRequest;

  Map<String, dynamic> get dataJson =>
      isJson ? data as Map<String, dynamic> : {};

  List<int>? get dataBytes => isBytes ? data as List<int> : null;

  String? get dataString => isPlain ? data as String : null;

  bool get isJson => originalRequest.responseType.isJson;

  bool get isPlain => originalRequest.responseType.isPlain;

  bool get isBytes => originalRequest.responseType.isBytes;

  bool get isSuccessRequest =>
      statusCode != null &&
      ![
        400, // Bad Request
        401, // Unauthorized
        402, // Payment Required
        403, // Forbidden
        404, // Not Found
        405, // Method Not Allowed,
        413, // Request Entity Too Large
        414, // Request URI Too Long,
        415, // Unsupported Media Type
      ].contains(statusCode);

  @override
  String toString() =>
      'SuccessResult(\nstatusCode: $statusCode, data: $data, headers: ${headers.toString()}\n)';

  @override
  bool operator ==(covariant SuccessResult other) {
    if (identical(this, other)) return true;

    return other.statusCode == statusCode &&
        other.data == data &&
        other.headers == headers &&
        other.originalRequest == originalRequest;
  }

  @override
  int get hashCode {
    return statusCode.hashCode ^
        data.hashCode ^
        headers.hashCode ^
        originalRequest.hashCode;
  }
}
