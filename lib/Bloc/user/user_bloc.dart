import 'dart:async';
import 'dart:ui';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dirasti/utils/cache.dart';
import 'package:bloc/bloc.dart';
import 'package:dirasti/utils/const.dart';
import 'package:dirasti/utils/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hms_gms_availability/flutter_hms_gms_availability.dart';
import 'package:huawei_push/huawei_push.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

import '../../module/grade_module.dart';
import '../../module/user_module.dart';

part 'user_event.dart';
part 'user_state.dart';
class UserBloc extends Bloc<UserEvent, UserState> {
  List<grade_module> grade_modules = [];
  user_module? user_model;

  UserBloc() : super(UserInitial()) {
    on<user_signin>(signin);
    on<grade_init>(grade);
    on<user_login>(login);
    on<user_update>(user_update_void);
  }

  Future<FutureOr<void>> signin(user_signin event, Emitter<UserState> emit) async {
    String? a;
    String? b;
   // await send_post_signin(event ,"empty","empty",2);
   //  try{
   //  FlutterHmsGmsAvailability.isGmsAvailable.then((t) async {
   //    if (t) {
   //      await FirebaseMessaging.instance.getToken().then((valued) async {
   //        a= valued?.split(":")[0];
   //        b= valued?.split(":")[1];
   //        print("end 1");
   //        await send_post_signin(event ,a??"empty",b??"empty",b==null ? 0:1);
   //       //await send_post_signin(event , valued?.split(":")[0],valued?.split(":")[1],1);
   //      });
   //    }else{
   //      await Push.getTokenStream.listen((valued) async {
   //        a=valued;
   //        print("end 0");
   //        await send_post_signin(event ,a??"empty",b??"empty",b==null ? 0:1);
   //       // await send_post_signin(event ,valued,"",0);
   //      });
   //    }
   //
   //  });
   //  }catch(e){
      await send_post_signin(event ,"empty","empty",2);
    // }

    //`name`, `email`, `is_male`, `course_file`,`grade`,`mobile_id`,`secret_code`
  }

  send_post_signin(user_signin event,gms1,gms2,is_gms) async {
    await dio.post_data(url: "/account/signin", quary: {
      "name": event.name,
      //"email": event.email,
      "is_male": event.is_male,
      "grade": event.grade,
      "mobile_id": event.mobile_id,
      "secret_code": cache.get_data("scode"),
      "gsm_token2":gms2,
      "gsm_token":gms1,
      "is_gms": is_gms,
    }).then((value) {
      if (value?.data == "error3") {
        emit(error_signin("مكرر"));
      } else {
        cache.save_data("TOKEN1", value?.data['token']);
        dio.cookieJar.loadForRequest(Uri.parse(value!.realUri.toString().split("?")[0])).then((value) async {
          cache.save_data("TOKEN2", value[0].value);
          await dio.init();
          await dio.post_data(url:"/index/login_id",quary: {
            // "user_id":cache.get_data("id"),
            "secret_code":cache.get_data("scode"),
          }).then((value){
            if(value?.data == "error1"){
            }else if(value?.data == "error2"){
            }else{
              user_model= user_module.fromjson(value?.data[0]);
              emit(scss_signin());
              //print(user_model?.id);
              // cache.save_data("id", user_model?.id);
              // emit(scss_login(user_model?.name));
            }
          });
        });
        // cache.save_data("id", value?.data);
        // emit(scss_signin());
      }
    });
  }

  Future<FutureOr<void>> grade(event, Emitter<UserState> emit) async {
    print("is init  is init");
    try{
    await dio.get_data(url:"/account/all_grade").then((value) {
      value?.data.forEach((e){
          grade_modules.add(grade_module.fromjson(e));
          //grade_modules.add(e);

        });

    });
  } catch(e){
      emit(error_signin("مكرر"));
    }finally{
      emit(init_state());
    }
    }

  Future<FutureOr<void>> login(user_login event, Emitter<UserState> emit) async {
    String? a ;
    String? b ;
  //  send_post_login(event.num,"empty","empty");
  //   try{
  //   await FlutterHmsGmsAvailability.isGmsAvailable.then((t) async {
  //     if (t) {
  //       await FirebaseMessaging.instance.getToken().then((valued) async {
  //         a= valued?.split(":")[0];
  //         b= valued?.split(":")[1];
  //         //send_post_login(event.num,valued?.split(":")[0],valued?.split(":")[1]);
  //         send_post_login(event.num,a??"empty",b??"empty");
  //       });
  //     }else{
  //
  //       Push.getTokenStream.listen((events) async {
  //
  //        // send_post_login(event.num,events,"");
  //         a= events;
  //         send_post_login(event.num,a??"empty",b??"empty");
  //       });
  //     }
  //     });
  //   } catch(e){
    send_post_login(event.num,"empty","empty");
  // }
  }
  Future<void> send_post_login(num,gms1,gms2) async {
    await dio.post_data(url: "account/login", quary: {
      "mobile_id": num,
      "secret_code": cache.get_data("scode"),
      "gsm_token2":gms2,
      "gsm_token":gms1,
    }).then((value) {
      if (value?.data == "error1") {
        emit(error_login("تم تسجيل الدخول من جوال اخر"));
      } else if (value?.data == "error2") {
        emit(error_login("غير موجود"));
      } else {
        cache.save_data("TOKEN1", value?.data['token']);
        dio.cookieJar.loadForRequest(Uri.parse(value!.realUri.toString().split("?")[0])).then((value) async {
          cache.save_data("TOKEN2", value[0].value);
          await dio.init();
          await dio.post_data(url:"/index/login_id",quary: {
           // "user_id":cache.get_data("id"),
            "secret_code":cache.get_data("scode"),
          }).then((value){
            if(value?.data == "error1"){
            }else if(value?.data == "error2"){
            }else{
              user_model= user_module.fromjson(value?.data[0]);
              emit(scss_login(user_model?.name));
              //print(user_model?.id);
              // cache.save_data("id", user_model?.id);
              // emit(scss_login(user_model?.name));
            }
          });

        });
        //user_model = user_module.fromjson(value?.data[0]);
        //cache.save_data("id", user_model?.id);
        //emit(scss_login(user_model?.name));
      }
    });
  }

  Future<FutureOr<void>> user_update_void(user_update event, Emitter<UserState> emit) async {
      await dio.post_data(url: "/account/update_account", quary: {
        "name": event.name,
        // "email": event.email,
        "is_male": event.is_male,
        "grade": event.grade,
        "mobile_id": event.mobile_id,
        "secret_code": cache.get_data("scode"),
      }).then((value) {
        if (value?.data == "error") {
          emit(faile_update_state());
        } else {
          emit(scss_update_state());
        }
      });
  }

  // Future<FutureOr<void>> init(user_init event, Emitter<UserState> emit) async {
  //   print("aaaaaaaaaaaaaaaaaaaaa");
  //   await dio.post_data(url:"/account/login_id",quary: {
  //     "user_id":event.id,
  //     "secret_code":cache.get_data("scode"),
  //   }).then((value){
  //     if(value?.data == "error1"){
  //       emit(error_login("تم تسجيل الدخول من جوال اخر"));
  //     }else if(value?.data == "error2"){
  //       emit(error_login("غير موجود"));
  //     }else{
  //       print(value?.data);
  //       user_model= user_module.fromjson(value?.data[0]);
  //       print(user_model?.id);
  //       print(user_model?.name);
  //
  //       // cache.save_data("id", user_model?.id);
  //       // emit(scss_login(user_model?.name));
  //     }
  //     print(value?.data);
  //   });
  // }
}

