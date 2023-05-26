import 'package:projectile/src/core/interceptors/queue.dart';
import 'package:projectile/src/core/request_models/request_models.dart';
import 'package:projectile/src/core/result_models/result.dart';

/// {@template interceptor_contract}
/// {@endtemplate}
abstract class ProjectileInterceptor {
  Future<ProjectileRequest> onRequest(ProjectileRequest data);

  Future<ProjectileResult> onResponse(ProjectileResult data);

  Future<ProjectileResult> onError(ProjectileResult data);

  // Future<InnerException> onException(InnerException data);
}

mixin RunInterceptor {
  Future<ProjectileRequest> runRequestInterceptors(
    Iterable<ProjectileInterceptor> interceptors,
    ProjectileRequest initialRequestData,
  ) {
    /// run before `request` interceptors
    final queue = FutureQueue<ProjectileRequest>()..addAll(interceptors.map((e) => e.onRequest));

    return queue.run(initialRequestData);
  }

  Future<ProjectileResult> runResponseInterceptors(
    Iterable<ProjectileInterceptor> interceptors,
    ProjectileResult initialRequestData,
  ) {
    /// run on `response` interceptors
    final queue = FutureQueue<ProjectileResult>()..addAll(interceptors.map((e) => e.onResponse));

    return queue.run(initialRequestData);
  }

  Future<ProjectileResult> runErrorInterceptors(
    Iterable<ProjectileInterceptor> interceptors,
    ProjectileResult initialRequestData,
  ) {
    /// run on `error` interceptors
    final queue = FutureQueue<ProjectileResult>()..addAll(interceptors.map((e) => e.onError));

    return queue.run(initialRequestData);
  }
}
