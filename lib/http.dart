import 'package:dio/dio.dart';

class Http {
  static Dio _dio;

  static Dio instance() {
    if (_dio == null) {
      var options = Options(baseUrl: 'http://dili.bdatu.com/jiekou');
      _dio = new Dio(options);
      _dio.interceptor.request.onSend = (Options options) {
        print("onSend: ${options.path.toString()}");
        // Do something before request is sent
        return options; //continue
        // If you want to resolve the request with some custom data，
        // you can return a `Response` object or return `dio.resolve(data)`.
        // If you want to reject the request with a error message,
        // you can return a `DioError` object or return `dio.reject(errMsg)`
      };
      _dio.interceptor.response.onSuccess = (Response response) {
        print("onSuccess: ${response.toString()}");
        return response; // continue
      };
      _dio.interceptor.response.onError = (DioError e) {
        print("onError: ${e.toString()}");
        return e; //continue
      };
    }
    return _dio;
  }
}
