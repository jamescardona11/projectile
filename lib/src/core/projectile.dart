import 'dart:async';

import 'package:projectile/src/client/http_client.dart';

import 'client/i_projectile_client.dart';
import 'request_models/request.dart';
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
