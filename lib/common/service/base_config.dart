import 'package:coffe_app/common/constants/service_const.dart';
import 'package:dio/dio.dart';

class BaseConfig {
  late Dio dio;

  BaseConfig() {
    BaseOptions options = BaseOptions(baseUrl: BASE_URL);
    dio = Dio(options);
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        return handler.next(options);
      },
      onResponse: (e, handler) async {
        return handler.next(e);
      },
      onError: (e, handler) async {
        return handler.next(e);
      },
    ));
  }
}
