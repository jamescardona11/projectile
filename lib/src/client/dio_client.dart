import 'dart:async';

import 'package:dio/dio.dart' hide Headers;
import 'package:projectile/src/core/client/i_projectile_client.dart';
import 'package:projectile/src/core/request_models/multipart_file.dart';
import 'package:projectile/src/core/request_models/request.dart';
import 'package:projectile/src/core/result_models/failure.dart';
import 'package:projectile/src/core/result_models/result.dart';
import 'package:projectile/src/core/result_models/success.dart';

/// {@template dio_client}
/// {@endtemplate}
class DioClient extends IProjectileClient {
  late Dio dioClient;

  DioClient({
    Dio? dio,
  }) {
    dioClient = dio ?? Dio();
  }

  @override
  Future<ProjectileResult> createRequest(ProjectileRequest request) async {
    final dataToRequest =
        request.isMultipart ? await _createFromMap(request) : request.data;

    try {
      final response = await dioClient.request(
        request.target,
        options: getOptions(request),
        data: dataToRequest,
      );

      if (isSuccessRequest(response.statusCode) &&
          request.customSuccess(response.data)) {
        return SuccessResult.def(
          statusCode: response.statusCode,
          headers: response.headers.map,
          data: response.data,
          // originalData: response.data,
          originalRequest: request,
        );
      } else {
        return FailureResult.def(
          originalRequest: request,
          error: response.data,
          statusCode: response.statusCode,
          headers: response.headers.map,
        );
      }
    } catch (err, stackTrace) {
      return FailureResult.def(
        originalRequest: request,
        error: err,
        stackTrace: stackTrace,
        statusCode: 100,
        // headers: response.headers,
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
  void finallyBlock() {
    dioClient.close();
  }

  Options getOptions(ProjectileRequest request) => Options(
        method: request.methodStr,
        headers: request.headers ?? {},
        contentType: request.contentType.value,
        responseType: _fromResponseType(request),
      );

  Future<FormData> _createFromMap(ProjectileRequest request) async {
    final multipart = await createNativeMultipartObject(request.multipart!);

    return FormData.fromMap(
      <String, dynamic>{}
        ..addAll(request.data)
        ..addAll({request.multipart!.field: multipart}),
    );
  }

  ResponseType _fromResponseType(ProjectileRequest request) {
    if (request.responseType.isJson) return ResponseType.json;
    if (request.responseType.isBytes) return ResponseType.bytes;

    return ResponseType.plain;
  }
}
