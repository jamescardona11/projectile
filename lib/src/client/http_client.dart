import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:projectile/src/core/client/i_projectile_client.dart';
import 'package:projectile/src/core/interceptors/interceptors.dart';
import 'package:projectile/src/core/misc_models/config.dart';
import 'package:projectile/src/core/request_models/multipart_file.dart';
import 'package:projectile/src/core/request_models/request.dart';
import 'package:projectile/src/core/result_models/result.dart';

/// {@template http_client}
/// {@endtemplate}
class HttpClient extends IProjectileClient {
  HttpClient({BaseConfig? config, List<ProjectileInterceptor> listInterceptors = const []})
      : super(config: config, listInterceptors: listInterceptors);

  final http.Client _httpClient = http.Client();

  @override
  Future<ProjectileResult> createRequest(
    ProjectileRequest request,
  ) async {
    final http.BaseRequest httpRequest;

    if (!request.isMultipart) {
      httpRequest = _transformProjectileRequest(request);
    } else {
      httpRequest = await _transformProjectileMultipartRequest(request);
    }

    try {
      final httpSendRequest = await _httpClient.send(httpRequest).timeout(timeout);

      final response = await http.Response.fromStream(httpSendRequest);

      dynamic data;

      try {
        data = jsonDecode(response.body);
      } catch (e) {}

      /// bytes
      data ??= response.bodyBytes;

      /// other
      data ??= response.body;

      if (isSuccessRequest(response.statusCode) && request.customSuccess(data)) {
        return ProjectileResult.success(
          statusCode: response.statusCode,
          headers: response.headers,
          data: data,
          originalRequest: request,
          // originalData: response.body,
        );
      } else {
        return ProjectileResult.err(
          originalRequest: request,
          error: data,
          statusCode: response.statusCode,
          headers: response.headers,
        );
      }
    } catch (err, stackTrace) {
      return ProjectileResult.err(
        originalRequest: request,
        error: err,
        stackTrace: stackTrace,
        statusCode: 100,
      );
    }
  }

  @override
  Future<http.MultipartFile> createNativeMultipartObject(
    MultipartFileWrapper multipartFileWrapper,
  ) async {
    final type = multipartFileWrapper.type;

    if (type.isBytes) {
      return http.MultipartFile.fromBytes(
        multipartFileWrapper.field,
        multipartFileWrapper.valueBytes!,
        filename: multipartFileWrapper.filename,
        contentType: multipartFileWrapper.contentType,
      );
    } else if (type.isString) {
      return http.MultipartFile.fromString(
        multipartFileWrapper.field,
        multipartFileWrapper.valueString!,
        filename: multipartFileWrapper.filename,
        contentType: multipartFileWrapper.contentType,
      );
    } else {
      return http.MultipartFile.fromPath(
        multipartFileWrapper.field,
        multipartFileWrapper.valuePath!,
        filename: multipartFileWrapper.filename,
        contentType: multipartFileWrapper.contentType,
      );
    }
  }

  @override
  bool get isHttpClient => true;

  @override
  void finallyBlock() {
    _httpClient.close();
  }

  http.Request _transformProjectileRequest(ProjectileRequest request) {
    final uri = Uri.parse(request.target);

    final httpRequest = http.Request(request.methodStr, uri)..headers.addAll(_asMap(request.headers ?? {}));
    httpRequest.body = jsonEncode(request.body);

    return httpRequest;
  }

  Future<http.MultipartRequest> _transformProjectileMultipartRequest(
    ProjectileRequest request,
  ) async {
    final uri = Uri.parse(request.target);

    final httpRequest = http.MultipartRequest(request.methodStr, uri)
      ..headers.addAll(_asMap(request.headers ?? {}))
      ..fields.addAll(request.body.map((key, value) => MapEntry(key, value.toString())))
      ..files.add(await createNativeMultipartObject(request.multipart!));

    return httpRequest;
  }

  Map<String, String> _asMap(Map<String, dynamic> headers) {
    final Map<String, String> newMap = {};
    if (headers.isEmpty) return newMap;

    headers.forEach((key, value) {
      if (value is String) {
        newMap[key] = value;
      } else if (value is List<String>) {
        newMap[key] = value.join(',');
      }
    });

    return newMap;
  }
}
