import 'package:example/api_request/reqres_urls.dart';
import 'package:example/model/user_model.dart';
import 'package:projectile/projectile.dart';

class ApiRequestWithHttp {
  Future<bool> login(String email, password) async {
    final response = await Projectile(client: DioClient(config: BaseConfig(enableLog: true, baseUrl: ReqresUrls.base)))
        .request(
          ProjectileRequest(
            target: ReqresUrls.loginUrl2,
            method: Method.POST,
            body: {
              "email": email,
              "password": password,
            },
          ),
        )
        .fire();

    return response.isFailure;
  }

  Future<UserModel?> getUserInfo(int id) async {
    final response =
        await Projectile().request(RequestBuilder.target(ReqresUrls.singleUserUrl).mode(Method.GET).urlParams({'id': id}).build()).fire();

    if (response.isFailure) {
      return null;
    } else {
      final user = UserModel.fromJson(response.data['data']);
      return user;
    }
  }

  Future<void> testPut() async {
    final result = await Projectile()
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
    final result = await Projectile()
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
    final result = await Projectile()
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
}
