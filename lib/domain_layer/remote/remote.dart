import 'package:dio/dio.dart';
import 'package:nations/nations.dart';

class DioHelper {
  static Dio dio = Dio();
  static init() {
    dio = Dio(
      BaseOptions(
          baseUrl: 'https://taxi.0store.net/api/',
          followRedirects: false,
          receiveDataWhenStatusError: true,
          validateStatus: (status) {
            // return status! < 400;
            return true;
          }),
    );
  }

  static Future<Response> getData({
    required String path,
    Map<String, dynamic>? query,
    String lang = 'en',
    String? token,
  }) async {
    dio.options.headers = {
      'Authorization': 'Bearer $token',
      'lang': Nations.locale,
      'Content-Type': 'application/json',
    };
    return await dio.get(
      path,
      queryParameters: query,
    );
  }

  static Future<Response> postData({
    required String path,
    required dynamic data,
    Map<String, dynamic>? query,
    String lang = 'en',
    String? token,
    url,
  }) async {
    dio.options.headers = {
      'lang': Nations.locale,
      'Authorization': 'Bearer ${token}',
      'Content-Type': 'application/json',
      "Accept": "application/json",
    };
    return await dio.post(
      path,
      data: data,
      queryParameters: query,
    );
  }

  static Future<Response> postDataRegister({
    required String path,
    required Map data,
    Map<String, dynamic>? query,
    String lang = 'en',
    url,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
      "Accept": "application/json",
      'lang': Nations.locale,
    };
    return await dio.post(
      path,
      data: data,
      queryParameters: query,
    );
  }

  static Future<Response> putData({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
    String lang = 'en',
    String? token,
  }) async {
    dio.options.headers = {
      'Authorization': token ?? '',
      'Content-Type': 'application/json',
      'lang': Nations.locale,
    };

    return dio.put(
      url,
      queryParameters: query,
      data: data,
    );
  }
}
