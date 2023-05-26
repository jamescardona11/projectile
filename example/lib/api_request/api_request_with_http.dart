import 'package:projectile/projectile.dart';
import 'package:example/api_request/reqres_urls.dart';
import 'package:example/model/user_model.dart';

class ApiRequestWithHttp {
  Future<bool> login(String email, password) async {
    final response = await Projectile(config: BaseConfig(enableLog: true, baseUrl: ReqresUrls.base))
        .request(
          ProjectileRequest(
            target: ReqresUrls.loginUrl2,
            method: Method.POST,
            data: {
              "email": email,
              "password": password,
            },
          ),
        )
        .fire();

    return response.fold(
      (_) => false,
      (s) => true,
    );
  }

  Future<UserModel?> getUserInfo(int id) async {
    final response =
        await Projectile().request(RequestBuilder.target(ReqresUrls.singleUserUrl).mode(Method.GET).urlParams({'id': id}).build()).fire();

    return response.fold((error) {
      return null;
    }, (success) {
      final user = UserModel.fromJson(success.data['data']);
      return user;
    });
  }

  Future<void> testPut() async {
    final result = await Projectile()
        .request(
          ProjectileRequest(
            method: Method.PUT,
            target: ReqresUrls.testUrl,
            data: {
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
