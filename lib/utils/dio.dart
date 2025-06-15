import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:dirasti/utils/cache.dart';
class dio {
  static late  Dio dios;
  static late CookieJar cookieJar;
  static init() {
    //const str = "aHR0cHM6Ly93b3JrYWJsZS1mb3Jlc3QtcXVvdGF0aW9uLmdsaXRjaC5tZS8=";
    const str = 'aHR0cDovLzEzLjI1MS4xMzguOTgvYXBwLw==';
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String decoded = stringToBase64.decode(str);
    cookieJar = CookieJar();
    dios = Dio(BaseOptions(

       baseUrl: decoded,
      //  baseUrl: "http://13.251.138.98/app/",
        validateStatus: (_)=>_!<800,
        receiveDataWhenStatusError: true,
       headers: {'Content-Type': 'application/json', "token":cache.get_data("TOKEN1") ?? "","cookie":"refreshToken="+(cache.get_data("TOKEN2")??"")}
     //   headers: {'Content-Type': 'application/json', "token":cache.get_data("TOKEN1") ?? "","cookie":Cookie.fromSetCookieValue(cache.get_data("TOKEN2")??"")}
    ));
    dios.interceptors.add(CookieManager(cookieJar));
  }

  static Future<Response?> get_data({url, quary}) async {
   // return await dios.get(url, queryParameters: quary);
    var valuea = await dios.get(url, queryParameters: quary);
    if(valuea.statusCode == 206){

      cache.save_data("TOKEN1", valuea?.data['token']);
      cache.save_data("TOKEN1", valuea?.data['token']);
      var valued = await dio.cookieJar.loadForRequest(Uri.parse(valuea!.realUri.toString().split("?")[0]));
      cache.save_data("TOKEN2", valued[0].value);
      await dio.init();
      return await dios.get(url, queryParameters: quary);
    }else{
      return  valuea;
    }
  }

  static Future<Response?> post_data(
      {url, quary, data}) async {
    // dios?.options.headers = {'lang': lang, 'Authorization': token};

    // await dios.post(url, queryParameters: quary, data: data).then((value) async {
    //   if(value.statusCode == 206){
    //     print("1");
    //     print(value?.data);
    //     cache.save_data("TOKEN1", value?.data['token']);
    //    await dio.cookieJar.loadForRequest(Uri.parse(value!.realUri.toString().split("?")[0])).then((valued) async {
    //       cache.save_data("TOKEN2", valued[0].value);
    //       await dio.init();
    //       print(valued[0]);
    //      return await dios.post(url, queryParameters: quary, data: data);
    //     });
    //   }else{
    //     print("2");
    //     print(value?.data);
    //     print(value.runtimeType);
    //     print(Future(() => value).runtimeType);
    //     return  value;
    //   }
    // });
    var valuea = await dios.post(url, queryParameters: quary, data: data);
    if(valuea.statusCode == 206){

      cache.save_data("TOKEN1", valuea?.data['token']);
      var valued = await dio.cookieJar.loadForRequest(Uri.parse(valuea!.realUri.toString().split("?")[0]));
      cache.save_data("TOKEN2", valued[0].value);
      await dio.init();
      return await dios.post(url, queryParameters: quary, data: data);
    }else{
      return  valuea;
    }
  }

}
