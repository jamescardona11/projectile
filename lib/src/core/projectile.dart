import 'dart:async';

import 'package:projectile/src/client/http_client.dart';

import 'client/i_projectile_client.dart';
import 'request_models/request_models.dart';
import 'result_models/result.dart';

class Projectile {
  late final IProjectileClient _client;

  ProjectileRequest? _request;

  Projectile({
    IProjectileClient? client,
  }) {
    _client = client ?? HttpClient();
  }

  Projectile request(ProjectileRequest request) {
    _request = request;
    return this;
  }

  Projectile create({
    required String target,
    required Method method,
    bool ignoreBaseUrl = false,
    bool isMultipart = false,
    MultipartFileWrapper? multipart,
    ContentType? contentType,
    PResponseType? responseType,
    Map<String, dynamic> headers = const {},
    Map<String, dynamic> urlParams = const {},
    Map<String, dynamic> queries = const {},
    Map<String, dynamic> body = const {},
    ValueGetterRequest? customSuccess,
  }) {
    _request = ProjectileRequest(
      target: target,
      method: method,
      ignoreBaseUrl: ignoreBaseUrl,
      contentType: contentType,
      headers: headers,
      isMultipart: isMultipart,
      responseType: responseType,
      urlParams: urlParams,
      queries: queries,
      body: body,
      multipart: multipart,
      customSuccess: customSuccess,
    );
    return this;
  }

  Future<ProjectileResult> fire() {
    _validRequestBeforeSending();

    final completer = Completer<ProjectileResult>();

    _client.sendRequest(
      _request!,
      completer,
    );

    _request = null;

    return completer.future;
  }

  void _validRequestBeforeSending() {
    if (_request == null) {
      throw Exception('Make sure that request is not null');
    }

    if (_request!.isMultipart && _request!.multipart == null) {
      throw Exception('Make sure that multipart in_request with multipart flag = true, is not null');
    }
  }
}
