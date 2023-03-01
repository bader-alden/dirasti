import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dirasti/module/subject_module.dart';
import 'package:dirasti/utils/cache.dart';
import 'package:meta/meta.dart';
import 'package:dirasti/utils/dio.dart';

import '../../module/user_module.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(MainInitial()) {
    on<init>(init_void);
  }
  user_module? user_model;
  List<subject_module> subject_list=[];
  Future<FutureOr<void>> init_void(init event, Emitter<MainState> emit) async {
    try{
      await dio.post_data(url:"/account/login_id",quary: {
        "user_id":cache.get_data("id"),
        "secret_code":cache.get_data("scode"),
      }).then((value){
        if(value?.data == "error1"){
          // emit(error_login("تم تسجيل الدخول من جوال اخر"));
        }else if(value?.data == "error2"){
          //  emit(error_login("غير موجود"));
        }else{
          print(value?.data);
          user_model= user_module.fromjson(value?.data[0]);
          //print(user_model?.id);
          // cache.save_data("id", user_model?.id);
          // emit(scss_login(user_model?.name));
        }
      });
      await dio.get_data(url: "/index/subject",quary: {"user_id":cache.get_data("id")}).then((value) {
        print(value?.data);
        value?.data.forEach((e){
          subject_list.add(subject_module.fromjson(e));
        });
      });
    }catch (e){}
   finally{
      print(subject_list[0].id);
      print(subject_list[1].subject);
      emit(init_state());
   }
  }
}
