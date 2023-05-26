import 'dart:async';

import '../interceptors/interceptors.dart';
import '../misc_models/config.dart';
import '../request_models/request_models.dart';
import '../result_models/result_models.dart';

/// {@template i_projectile_client}
/// {@endtemplate}
abstract class IClient<T> {
  // late Completer<T> completer;

  Future<T> sendRequest(
    ProjectileRequest request,
    Completer<T> completer,
  );

  Future<dynamic> createNativeMultipartObject(
      MultipartFileWrapper multipartFileWrapper);

  void finallyBlock();
}

abstract class IProjectileClient extends IClient<ProjectileResult>
    with RunInterceptor {
  BaseConfig _config = const BaseConfig();
  final List<ProjectileInterceptor> _listInterceptors = [];

  IProjectileClient() {
    // if (config.enableLog) {
    //   addAllInterceptors([BasicProjectileLogs(config.logsTag)]);
    // }
  }

  void addNewConfig(BaseConfig newConfig) {
    _config = newConfig;
    if (_config.enableLog) {
      addAllInterceptors([BasicProjectileLogs(_config.logsTag)]);
    }
  }

  void addAllInterceptors(List<ProjectileInterceptor> interceptors) {
    _listInterceptors.addAll(interceptors);
  }

  /// override this to implement request
  /// don't catch exception if you want. is catch by default by `runRequest`
  Future<ProjectileResult> createRequest(ProjectileRequest request);

  @override
  Future<ProjectileResult> sendRequest(
    ProjectileRequest request,
    Completer<ProjectileResult> completer,
  ) {
    request.addDefaultHeaders(_config);

    String finalTarget = '';
    if (_config.isHttpClient) {
      finalTarget = request.getUri(_config.baseUrl).toString();
    } else {
      finalTarget = request.getUrl(_config.baseUrl);
    }

    return _sendRequest(
      request.copyWith(target: finalTarget),
      completer,
    );
  }

  /// Run request and everything relate to response and catch errors
  Future<ProjectileResult> _sendRequest(
    ProjectileRequest request,
    Completer<ProjectileResult> completer,
  ) async {
    try {
      final requestData = await _beforeRequest(request);
      _runFromCreate(requestData, completer);
    } catch (error, stackTrace) {
      _responseError(
          FailureResult.def(
            originalRequest: request,
            error: error,
            stackTrace: stackTrace,
          ),
          completer);
    }

    return completer.future;
  }

  /// Run `createRequest` and get response
  Future<void> _runFromCreate(
    ProjectileRequest requestData,
    Completer<ProjectileResult> completer,
  ) async {
    final responseRequest = await createRequest(requestData);

    if (responseRequest.isSuccess) {
      _responseSuccess(responseRequest as SuccessResult, completer);
    } else {
      _responseError(responseRequest as FailureResult, completer);
    }
  }

  /// Before start the request in `createRequest`
  Future<ProjectileRequest> _beforeRequest(ProjectileRequest request) =>
      runRequestInterceptors(_listInterceptors, request);

  /// Request success
  Future<void> _responseSuccess(
    SuccessResult responseData,
    Completer<ProjectileResult> completer,
  ) async {
    final response =
        await runResponseInterceptors(_listInterceptors, responseData);
    completer.complete(response);
  }

  /// Request error
  Future<void> _responseError(
    FailureResult error,
    Completer<ProjectileResult> completer,
  ) async {
    final errorData = await runErrorInterceptors(_listInterceptors, error);
    completer.complete(errorData);
  }

  Duration get timeout => _config.timeout;

  bool isSuccessRequest(int? statusCode) =>
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
}
