import 'dart:io';

import 'package:booktokenapp/config/app_config.dart';
import 'package:booktokenapp/constants/api_constant.dart';
import 'package:booktokenapp/models/api_response_model.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';

class ApiService {
  Dio _dio = Dio(BaseOptions(
    connectTimeout: 5000,
    receiveTimeout: 5000,
    sendTimeout: 5000,
  ));
  final String domainUrl = AppConfig.domainUrl;
  final String baseUrl = AppConfig.baseUrl;

  addCookieInceptor() async {
    print('before');
    print(await getCookies());
    var cookieJar = await getCookieJar();
    _dio.interceptors.add(CookieManager(cookieJar));
  }

  Future<CookieJar> getCookieJar() async {
    Directory appDoc = await getApplicationDocumentsDirectory();
    var path = appDoc.path;
    CookieJar cookieJar = PersistCookieJar(storage: FileStorage(path + '/.cookies/'));
    return cookieJar;
  }

  Future<void> clearCookies() async {
    var cookieJar = await getCookieJar();
    return await cookieJar.deleteAll();
  }

  Future<List<Cookie>> getCookies() async {
    var cookieJar = await getCookieJar();

    return await cookieJar.loadForRequest(Uri.parse(domainUrl));
  }

  Future<ApiResponse> get(String path) async {
    try {
      print(baseUrl + path);
      var response = await _dio.get(baseUrl + path);

      return _customResponse((response.data));
    } catch (e) {
      print(e);
      return _customErrorResponse(e);
    }
  }

  Future<ApiResponse> post(String path, dynamic data) async {
    print(baseUrl + path);

    try {
      var response = await _dio.post(baseUrl + path, data: data);

      print(response.data);
      return _customResponse(response.data);
    } catch (e) {
      print(e);
      return _customErrorResponse(e);
    }
  }

  ApiResponse _customErrorResponse(e) {
    print(e);
    if (e is DioError && e.type == DioErrorType.response && e.response!.data.runtimeType != String) {
      return ApiResponse(e.response!.data!["status"], {}, e.response!.data!["errorMsg"], true);
    } else {
      return ApiResponse(500, {}, "server error", true);
    }
  }

  ApiResponse _customResponse(dynamic data) {
    return ApiResponse(data!["status"], data["data"], '', false);
  }
}
