import 'package:dio/dio.dart';

Dio getDio(String baseUrl) {
  var dio = Dio()..options.baseUrl = baseUrl;
  return dio
    ..interceptors.add(
      LogInterceptor(
        requestHeader: false,
        requestBody: true,
        responseBody: false,
        responseHeader: false,
        error: false,
      ),
    );
}
