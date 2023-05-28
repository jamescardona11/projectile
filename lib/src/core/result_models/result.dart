import 'dart:async';
import 'dart:io';

import 'package:projectile/src/core/request_models/request.dart';

/// {@template result}
///
/// A value that represents either a success or a failure, including an
/// associated value in each case.
///
/// {@endtemplate}
class ProjectileResult {
  /// Request info.
  final ProjectileRequest originalRequest;

  /// The original error/exception object; It's usually not null when `type`
  final dynamic error;
  final StackTrace? stackTrace;
  final ProjectileErrorType? type;

  /// Response
  final dynamic data;
  final int? statusCode;
  final Map<String, dynamic>? headers;

  ProjectileResult._({
    required this.originalRequest,
    this.error,
    this.data,
    this.stackTrace,
    this.headers,
    this.statusCode,
    this.type,
  });

  factory ProjectileResult.success({
    required dynamic data,
    required Map<String, dynamic> headers,
    required ProjectileRequest originalRequest,
    int? statusCode,
  }) =>
      ProjectileResult._(
        headers: headers,
        data: data,
        originalRequest: originalRequest,
        statusCode: statusCode,
      );

  factory ProjectileResult.err({
    required dynamic error,
    required ProjectileRequest originalRequest,
    Map<String, dynamic> headers = const {},
    int? statusCode,
    StackTrace? stackTrace,
  }) =>
      ProjectileResult._(
        headers: headers,
        error: error,
        originalRequest: originalRequest,
        stackTrace: stackTrace,
        statusCode: statusCode,
        type: ProjectileErrorType.fromError(error),
      );

  /// Returns true if [Result] is [Failure].
  bool get isFailure => error != null;

  /// Returns true if [Result] is [Success].
  bool get isSuccess => data != null;

  Map<String, dynamic> get dataJson => data is Map<String, dynamic> ? data as Map<String, dynamic> : {};

  List<int>? get dataBytes => data is List<int> ? data as List<int> : null;

  String? get dataString => data is String ? data as String : null;

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

  String get message => (error?.toString() ?? '');

  @override
  String toString() {
    if (isSuccess) {
      return 'SuccessResult(\nstatusCode: $statusCode, data: $data, headers: ${headers.toString()}\n)';
    }

    var msg = 'FailureResult [$type]: $message ';
    if (error is Error) {
      msg += '\n${(error as Error).stackTrace}';
    }
    if (stackTrace != null) {
      msg += '\nSource stack:\n$stackTrace';
    }
    return msg;
  }
}

enum ProjectileErrorType {
  connectTimeout,
  socketError,

  /// When the server response, but with a incorrect status, such as 404, 503...
  response,

  // unexpected error
  other;

  static ProjectileErrorType fromError(Object error) {
    if (error is TimeoutException) {
      return connectTimeout;
    } else if (error is SocketException) {
      return socketError;
    } else if (error is Exception) {
      return other;
    }

    return response;
  }
}
