import 'dart:async';
import 'dart:io';

import 'package:projectile/src/core/request_models/request.dart';
import 'package:projectile/src/core/result_models/result.dart';

/// {@template failure}
/// inspired on DIOError class
///
/// {@endtemplate}
class FailureResult extends ProjectileResult {
  FailureResult._({
    required this.originalRequest,
    this.error,
    this.stackTrace,
    this.headers,
    this.statusCode,
  }) : type = ProjectileErrorType.fromError(error);

  factory FailureResult.def({
    required dynamic error,
    required ProjectileRequest originalRequest,
    Map<String, dynamic> headers = const {},
    int? statusCode,
    StackTrace? stackTrace,

    // this.originalData,
  }) =>
      FailureResult._(
        headers: headers,
        error: error,
        originalRequest: originalRequest,
        stackTrace: stackTrace,
        statusCode: statusCode,
      );

  /// Request info.
  final ProjectileRequest originalRequest;
  final int? statusCode;
  final Map<String, dynamic>? headers;

  /// The original error/exception object; It's usually not null when `type`

  final dynamic error;
  final StackTrace? stackTrace;

  final ProjectileErrorType type;

  String get message => (error?.toString() ?? '');

  @override
  String toString() {
    var msg = 'FailureResult [$type]: $message ';
    if (error is Error) {
      msg += '\n${(error as Error).stackTrace}';
    }
    if (stackTrace != null) {
      msg += '\nSource stack:\n$stackTrace';
    }
    return msg;
  }

  @override
  bool operator ==(covariant FailureResult other) {
    if (identical(this, other)) return true;

    return other.originalRequest == originalRequest &&
        other.statusCode == statusCode &&
        other.headers == headers &&
        other.error == error &&
        other.stackTrace == stackTrace &&
        other.type == type;
  }

  @override
  int get hashCode {
    return originalRequest.hashCode ^
        statusCode.hashCode ^
        headers.hashCode ^
        error.hashCode ^
        stackTrace.hashCode ^
        type.hashCode;
  }
}

enum ProjectileErrorType {
  connectTimeout,
  socketError,

  /// When the server response, but with a incorrect status, such as 404, 503...
  response,

  // unexpected error
  other;

  bool get isResponse => this == response;

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
