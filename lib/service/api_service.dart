import 'dart:io';

import 'package:booktokenapp/constants/api_constant.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';

class ApiService {
  Dio _dio = Dio(BaseOptions(connectTimeout: 5000, receiveTimeout: 5000, sendTimeout: 5000));

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

  Future<List<Cookie>> getCookies() async {
    var cookieJar = await getCookieJar();

    return await cookieJar.loadForRequest(Uri.parse(domainUrl));
  }

  get(String path) async {
    try {
      var response = await _dio.get(baseUrl + path);
      return _customResponse((response.data["data"]));
    } catch (e) {
      print(e);
      return _customErrorResponse(e);
    }
  }

  post(String path, dynamic data) async {
    try {
      var response = await _dio.post(baseUrl + path, data: data);
      return _customResponse(response.data["data"]);
    } catch (e) {
      print(e);
      return _customErrorResponse(e);
    }
  }

  _customErrorResponse(e) {
    Map<String, dynamic> customErrorResponse = {"error": true, "code": null, "errorMsg": ""};

    print(e);
    if (e is DioError && e.type == DioErrorType.response) {
      customErrorResponse["error"] = true;
      customErrorResponse["code"] = e.response!.data!["status"];
      customErrorResponse["errorMsg"] = e.response!.data!["errorMsg"];
      return customErrorResponse;
    } else {
      customErrorResponse["error"] = true;
      customErrorResponse["code"] = 500;
      customErrorResponse["errorMsg"] = "server error";
      return customErrorResponse;
    }
  }

  _customResponse(dynamic data) {
    Map<String, dynamic> customErrorResponse = {"error": false, "code": null, "data": ""};

    customErrorResponse["error"] = false;
    customErrorResponse["code"] = 200;
    customErrorResponse["data"] = data;
    return customErrorResponse;
  }
}
