import 'package:dio/dio.dart';
import 'package:flutter_application/src/api-services/SharedPreference.dart';

class AuthInterceptor extends Interceptor {
  String authToken;

  AuthInterceptor(this.authToken);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    authToken = (await SharedPreference().getJwtToken())!;
    options.headers['Authorization'] = 'Bearer $authToken';
    return super.onRequest(options, handler);
  }
}
