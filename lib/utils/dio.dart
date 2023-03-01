import 'package:dio/dio.dart';

class dio {
  static Dio? dios;
  static init() {
    dios = Dio(BaseOptions(
        baseUrl: "https://ubiquitous-sepia-rainforest.glitch.me",
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
