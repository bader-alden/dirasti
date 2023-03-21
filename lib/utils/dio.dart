import 'package:dio/dio.dart';
import 'dart:convert';

class dio {
  static Dio? dios;
  static init() {
    final str = "aHR0cHM6Ly91YmlxdWl0b3VzLXNlcGlhLXJhaW5mb3Jlc3QuZ2xpdGNoLm1l";
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String decoded = stringToBase64.decode(str);
    dios = Dio(BaseOptions(
        baseUrl: decoded,
        receiveDataWhenStatusError: true,
        headers: {'Content-Type': 'application/json'}));
  }

  static Future<Response?> get_data({url, quary}) async {

    return await dios?.get(url, queryParameters: quary);
  }

  static Future<Response?> post_data(
      {url, quary, data}) async {
    // dios?.options.headers = {'lang': lang, 'Authorization': token};

    return dios?.post(url, queryParameters: quary, data: data);
  }

  static Future<Response?> put_data(
      {url, quary, data}) async {

    return dios?.put(url, queryParameters: quary, data: data);
  }
}
