import 'dart:async';

import 'package:projectile/src/client/dio_client.dart';
import 'package:projectile/src/client/http_client.dart';

import 'client/i_projectile_client.dart';
import 'interceptors/interceptor_contract.dart';
import 'misc_models/config.dart';
import 'request_models/request.dart';
import 'result_models/result.dart';

//Result<IProjectileError, IProjectileResponse>
class Projectile {
  late final IProjectileClient _client;
  final BaseConfig? config;
  List<ProjectileInterceptor> interceptors;
  ProjectileRequest? _request;

  Projectile({
    IProjectileClient? client,
    this.config,
    this.interceptors = const [],
  }) {
    _client = client ?? DioClient();
    if (config != null) {
      _client.addNewConfig(config!.copyWith(
        isHttp: _client is HttpClient,
      ));
      _client.addAllInterceptors(interceptors);
    }
  }

  Projectile request(ProjectileRequest request) {
    _request = request;
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
    // if (_client == null) {
    //   throw Exception(
    //       'Make sure that _client implementation of IProjectileClient is not null, check the client folder to see example for dio/http');
    // }

    if (_request == null) {
      throw Exception('Make sure that request is not null');
    }

    if (_request!.isMultipart && _request!.multipart == null) {
      throw Exception(
          'Make sure that multipart in_request with multipart flag = true, is not null');
    }
  }
}
