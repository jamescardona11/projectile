import 'dart:async';

import 'package:dio/dio.dart' hide Headers;
import 'package:projectile/src/core/client/i_projectile_client.dart';
import 'package:projectile/src/core/interceptors/interceptor_contract.dart';
import 'package:projectile/src/core/misc_models/config.dart';
import 'package:projectile/src/core/request_models/multipart_file.dart';
import 'package:projectile/src/core/request_models/request.dart';
import 'package:projectile/src/core/result_models/result.dart';

/// {@template dio_client}
/// {@endtemplate}
class DioClient extends IProjectileClient {
  late Dio dioClient;

  DioClient({
    Dio? dio,
    BaseConfig? config,
    List<ProjectileInterceptor> listInterceptors = const [],
  }) : super(config: config, listInterceptors: listInterceptors) {
    dioClient = dio ?? Dio();
  }

  @override
  Future<ProjectileResult> createRequest(ProjectileRequest request) async {
    final dataToRequest = request.isMultipart ? await _createFromMap(request) : request.body;

    try {
      final response = await dioClient.request(
        request.target,
        options: getOptions(request),
        data: dataToRequest,
      );

      if (isSuccessRequest(response.statusCode) && request.customSuccess(response.data)) {
        return ProjectileResult.success(
          statusCode: response.statusCode,
          headers: response.headers.map,
          data: response.data,
          // originalData: response.data,
          originalRequest: request,
        );
      } else {
        return ProjectileResult.err(
          originalRequest: request,
          error: response.data,
          statusCode: response.statusCode,
          headers: response.headers.map,
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
  Future<MultipartFile> createNativeMultipartObject(
    MultipartFileWrapper multipartFileWrapper,
  ) async {
    final type = multipartFileWrapper.type;

    if (type.isBytes) {
      return MultipartFile.fromBytes(
        multipartFileWrapper.valueBytes!,
        filename: multipartFileWrapper.filename,
        contentType: multipartFileWrapper.contentType,
      );
    } else if (type.isString) {
      return MultipartFile.fromString(
        multipartFileWrapper.valueString!,
        filename: multipartFileWrapper.filename,
        contentType: multipartFileWrapper.contentType,
      );
    } else {
      return MultipartFile.fromFile(
        multipartFileWrapper.valuePath!,
        filename: multipartFileWrapper.filename,
        contentType: multipartFileWrapper.contentType,
      );
    }
  }

  @override
  bool get isHttpClient => false;

  @override
  void finallyBlock() {
    dioClient.close();
  }

  Options getOptions(ProjectileRequest request) => Options(
        method: request.methodStr,
        headers: request.headers,
        responseType: _fromResponseType(request),
      );

  Future<FormData> _createFromMap(ProjectileRequest request) async {
    final multipart = await createNativeMultipartObject(request.multipart!);

    return FormData.fromMap(
      <String, dynamic>{}
        ..addAll(request.body)
        ..addAll({request.multipart!.field: multipart}),
    );
  }

  ResponseType? _fromResponseType(ProjectileRequest request) {
    if (request.responseType?.isJson ?? false) return ResponseType.json;
    if (request.responseType?.isBytes ?? false) return ResponseType.bytes;

    return null;
  }
}
