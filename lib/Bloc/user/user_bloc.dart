import 'dart:async';
import 'dart:ui';
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
    FlutterHmsGmsAvailability.isGmsAvailable.then((t) async {
      if (t) {
        await FirebaseMessaging.instance.getToken().then((valued) async {
          await dio.post_data(url: "/account/signin", quary: {
            "name": event.name,
            //"email": event.email,
            "is_male": event.is_male,
            "grade": event.grade,
            "mobile_id": event.mobile_id,
            "secret_code": cache.get_data("scode"),
            "gsm_token2":valued?.split(":")[1],
            "gsm_token":valued?.split(":")[0],
            "is_gms": '1',
          }).then((value) {
            if (value?.data == "error3") {
              emit(error_signin("مكرر"));
            } else {
              cache.save_data("id", value?.data);
              emit(scss_signin());
            }
          });
        });
      }else{
        await Push.getId().then((valued) async {
          await dio.post_data(url: "/account/signin", quary: {
            "name": event.name,
            //"email": event.email,
            "is_male": event.is_male,
            "grade": event.grade,
            "mobile_id": event.mobile_id,
            "secret_code": cache.get_data("scode"),
            // "gsm_token2":valued?.split(":")[1],
            "gsm_token":valued,
            "is_gms": '0',
          }).then((value) {
            if (value?.data == "error3") {
              emit(error_signin("مكرر"));
            } else {
              cache.save_data("id", value?.data);
              emit(scss_signin());
            }
          });
        });
      }

    });

    //`name`, `email`, `is_male`, `course_file`,`grade`,`mobile_id`,`secret_code`
  }

  Future<FutureOr<void>> grade(event, Emitter<UserState> emit) async {
    print("is init  is init");
    try{
    await dio.get_data(url:"/index/all_grade").then((value) {
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
    await FlutterHmsGmsAvailability.isGmsAvailable.then((t) async {
      if (t) {
        await FirebaseMessaging.instance.getToken().then((valued) async {
          await dio.post_data(url: "/account/login", quary: {
            "mobile_id": event.num,
            "secret_code": cache.get_data("scode"),
            "gsm_token2":valued?.split(":")[1],
            "gsm_token":valued?.split(":")[0],
          }).then((value) {
            if (value?.data == "error1") {
              emit(error_login("تم تسجيل الدخول من جوال اخر"));
            } else if (value?.data == "error2") {
              emit(error_login("غير موجود"));
            } else {
              user_model = user_module.fromjson(value?.data[0]);
              cache.save_data("id", user_model?.id);
              emit(scss_login(user_model?.name));
            }
          });
        });
      }else{
        Push.getTokenStream.listen((events) async {
          await dio.post_data(url: "/account/login", quary: {
            "mobile_id": event.num,
            "secret_code": cache.get_data("scode"),
            // "gsm_token2":valued?.split(":")[1],
             "gsm_token":events,
          }).then((value) {
            if (value?.data == "error1") {
              emit(error_login("تم تسجيل الدخول من جوال اخر"));
            } else if (value?.data == "error2") {
              emit(error_login("غير موجود"));
            } else {
              user_model = user_module.fromjson(value?.data[0]);
              cache.save_data("id", user_model?.id);
              emit(scss_login(user_model?.name));
            }
          });
        });
      }
      });



  //  });


    //`name`, `email`, `is_male`, `course_file`,`grade`,`mobile_id`,`secret_code`

  }



  Future<FutureOr<void>> user_update_void(user_update event, Emitter<UserState> emit) async {
    await FirebaseMessaging.instance.getToken().then((valued) async {
      await dio.post_data(url: "/account/update_account", quary: {
        "name": event.name,
        // "email": event.email,
        "is_male": event.is_male,
        "grade": event.grade,
        "mobile_id": event.mobile_id,
        "secret_code": cache.get_data("scode"),
        "gsm_token2": valued?.split(":")[1],
        "gsm_token": valued?.split(":")[0],
      }).then((value) {
        if (value?.data == "error") {
          emit(faile_update_state());
        } else {
          emit(scss_update_state());
        }
      });
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

