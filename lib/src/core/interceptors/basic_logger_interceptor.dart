import 'package:projectile/src/core/request_models/request.dart';
import 'package:projectile/src/core/result_models/result_models.dart';
import 'dart:developer' as developer;

import 'interceptors.dart';

/// {@template basic_logger_interceptor}
/// {@endtemplate}
class BasicProjectileLogs extends ProjectileInterceptor {
  BasicProjectileLogs(this.log);

  final String log;

  @override
  Future<FailureResult> onError(FailureResult data) async {
    developer.log('$log Error =>\n $data');

    return data;
  }

  @override
  Future<ProjectileRequest> onRequest(ProjectileRequest data) async {
    // String finalTarget = '';
    // if (data.baseConfig!.isHttp) {
    //   finalTarget = data.getUri(data.baseConfig!.baseUrl).toString();
    // } else {
    //   finalTarget = data.getUrl(data.baseConfig!.baseUrl);
    // }
    developer.log('$log Request=>\n $data');
    return data;
  }

  @override
  Future<SuccessResult> onResponse(SuccessResult data) async {
    developer.log('$log Response=>\n $data');
    return data;
  }

  // @override
  // Future<InnerException> onException(InnerException data) async {
  //   developer.log('$log Exception=>\n $data');
  //   return data;
  // }
}
