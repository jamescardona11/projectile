import 'package:example/api_request/reqres_urls.dart';
import 'package:projectile/projectile.dart';

import '../model/user_model.dart';

class ApiRequestWithDio {
  Future<Iterable<UserModel>> getAllUsers({int page = 1}) async {
    final result = await Projectile(client: DioClient())
        .request(
          RequestBuilder.target(ReqresUrls.listUsersUrl).mode(Method.GET).queries({'n': page}).build(),
        )
        .fire();

    if (result.isFailure) {
      return [];
    } else {
      return (result.dataJson['data'] as List<dynamic>).map((e) => UserModel.fromJson(e));
    }
  }

  Future<void> testPut() async {
    final result = await Projectile(client: DioClient())
        .request(
          ProjectileRequest(
            method: Method.PUT,
            target: ReqresUrls.testUrl,
            body: {
              "name": "morpheus",
              "job": "leader",
            },
          ),
        )
        .fire();

    print('Result PUT DIO:');
    print(result);
  }

  Future<void> testDelete() async {
    final result = await Projectile(client: DioClient())
        .request(
          ProjectileRequest(
            method: Method.DELETE,
            target: ReqresUrls.testUrl,
          ),
        )
        .fire();

    print('Result DELETE DIO:');
    print(result);
  }

  Future<void> testPatch() async {
    final result = await Projectile(client: DioClient())
        .request(
          ProjectileRequest(
            method: Method.PATCH,
            target: ReqresUrls.testUrl,
          ),
        )
        .fire();

    print('Result PATCH DIO:');
    print(result);
  }

  Future<void> testPOST() async {
    final result = await Projectile(client: DioClient())
        .request(
          ProjectileRequest(
            method: Method.POST,
            target: ReqresUrls.testPostUrl,
            body: {
              "name": "morpheus",
              "job": "leader",
            },
          ),
        )
        .fire();

    print('Result POST DIO:');
    print(result);
  }
}
