import 'dart:developer' as developer;

import 'package:projectile/src/core/request_models/request.dart';
import 'package:projectile/src/core/result_models/result.dart';

import 'interceptors.dart';

/// {@template basic_logger_interceptor}
/// {@endtemplate}
class BasicProjectileLogs extends ProjectileInterceptor {
  BasicProjectileLogs(this.log);

  final String log;

  @override
  Future<ProjectileRequest> onRequest(ProjectileRequest data) async {
    developer.log('$log Request=>\n $data');
    return data;
  }

  @override
  Future<ProjectileResult> onError(ProjectileResult data) async {
    developer.log('$log Error =>\n $data');

    return data;
  }

  @override
  Future<ProjectileResult> onResponse(ProjectileResult data) async {
    developer.log('$log Response=>\n $data');
    return data;
  }
}
