import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:wonder_tool/helpers/public.dart';
import 'package:wonder_tool/apis/urls.dart';

const int connectTimeoutAPI = 100000;
const int receiveTimeoutAPI = 100000;

class ApiService {
  late Dio _dio;

  ApiService() {
    _init();
  }

  Future<Response?> getApi({
    required String url,
    Map<String, dynamic>? params,
  }) async {
    try {
      final res = await _dio.get(url, queryParameters: params);
      return res;
    } on DioError catch (e) {
      if (e.response != null) {
        print("Dio Error 1 response data: ${e.response!.data}");
        print("Dio Error 1 response header: ${e.response!.headers}");
        print(
            "Dio Error 1 response requestOption: ${e.response!.requestOptions.data}");
      } else {
        print("Dio Error 2 requestOption: ${e.requestOptions.data}");
        print("Dio Error 2: ${e.message}");
      }

      return null;
    }
  }

  Future<Response?> postApi({required String url, required body}) async {
    try {
      final res = await _dio.post(url, data: body);
      return res;
    } on DioError catch (e) {
      if (e.response != null) {
        print("Dio Error 1 response data: ${e.response!.data}");
        print("Dio Error 1 response header: ${e.response!.headers}");
        print(
            "Dio Error 1 response requestOption: ${e.response!.requestOptions.data}");
      } else {
        print("Dio Error 2 requestOption: ${e.requestOptions.data}");
        print("Dio Error 2: ${e.message}");
      }

      return null;
    }
  }

  void _initializeInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print(
              "\n---START---\n${options.method} | ${options.baseUrl}${options.path} \n params => ${options.queryParameters} \n body => ${options.data} \nResponse =>");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print(
              "${response.statusCode} ${response.statusMessage} ${response.data}\n---END---\n");
          return handler.next(response);
        },
        onError: (error, handler) {
          if (error.message.contains("SocketException")) {
            showErrorSnackBar('No Internet connection');
          }

          print(error.message);
          print(error.requestOptions.data);
          return handler.next(error);
        },
      ),
    );
  }

  void _init() {
    _dio = Dio(
      BaseOptions(
        baseUrl: BASE_URL,
        connectTimeout: connectTimeoutAPI,
        receiveTimeout: receiveTimeoutAPI,
      ),
    );

    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback = (cert, host, port) => true;
      return client;
    };

    _initializeInterceptors();
  }
}
