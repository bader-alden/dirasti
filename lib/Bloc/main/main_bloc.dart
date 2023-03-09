import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dirasti/module/course_module.dart';
import 'package:dirasti/module/part_module.dart';
import 'package:dirasti/module/subject_module.dart';
import 'package:dirasti/utils/cache.dart';
import 'package:meta/meta.dart';
import 'package:dirasti/utils/dio.dart';
import '../../Layout/courses_details.dart';
import '../../module/teacher_module.dart';
import '../../module/user_module.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(MainInitial()) {
    on<init>(init_void);
    on<init_porfile1>(init_porfile1_void);
    on<init_porfile2>(init_porfile2_void);
    on<get_teatcher_event>(get_teatcher_void);
    on<get_course_event>(get_course_void);
    on<get_course_details_event>(get_course_details_void);
    on<get_file_details_event>(get_file_details_void);
    on<watch_event>(watch_void);
    on<get_exam_event>(get_exam_void);
    on<get_file_event>(get_file_void);
  }
  user_module? user_model;
  List<subject_module> subject_list=[];
  List<teacher_module> teacher_list=[];
  List<course_module> course_list=[];
  List<part_module> part_list=[];
  List<String> part_tab_list=[];
  List<Map> all_file_list=[];
  List<Map<String,dynamic>> all_exam_list=[];
  int porfile_tab_index=1;
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
      subject_list.clear();
      await dio.get_data(url: "/index/subject",quary: {"user_id":cache.get_data("id")}).then((value) {
        print(value?.data);
        value?.data.forEach((e){
          subject_list.add(subject_module.fromjson(e));
        });
      });
    }catch (e){}
   finally{
      emit(init_state());
   }
  }

  Future<FutureOr<void>> get_teatcher_void(get_teatcher_event event, Emitter<MainState> emit) async {
    try{
      await dio.get_data(url:"/index/teatcher",quary: {
        "subject":event.name,
        "grade":event.grade
      }).then((value) {
        print(value?.data);
        value?.data.forEach((e){
          teacher_list.add(teacher_module.fromjson(e));
        });

      });
    }catch(e){

    }finally{
      emit(teacher_state());
    }

  }

  Future<FutureOr<void>> get_course_void(get_course_event event, Emitter<MainState> emit) async {
    try{
      await dio.get_data(url:"/index/course",quary: {
        "subject":event.subject,
        "grade":event.grade,
        "teacher_name":event.teacher,
      }).then((value) {
        print(value?.data);
        value?.data.forEach((e){
          course_list.add(course_module.fromjson(e));
         // teacher_list.add(teacher_module.fromjson(e));
        });

      });
    }catch(e){

    }finally{
      emit(course_state());
    }
  }

  Future<FutureOr<void>> get_course_details_void(get_course_details_event event, Emitter<MainState> emit) async {
    print("start");
    try{
      await dio.get_data(url:"/index/part",quary: {
        "subject":event.subject,
        "grade":event.grade,
        "teacher_name":event.teacher,
        "course":event.course,
        "user_id":cache.get_data("id"),
        "is_course":1,
      }).then((value) {
       // print(value?.data);
        if(value?.data=="notfound"){
          emit(not_sub_state());
        }else{
          value?.data.forEach((e){
            part_list.add(part_module.fromjson(e));
          });
          emit(sub_state());
        }
        // value?.data.forEach((e){
        // //  course_list.add(course_module.fromjson(e));
        //   // teacher_list.add(teacher_module.fromjson(e));
        // });

      });
    }catch(e){
      print(e);
    }finally{
      // print(part_list[0].name);
      // print(part_list[0].part?[0].name);
     // print(part_list[0].part?[0].res);
      part_list.forEach((element) {
        part_tab_list.add(element.name!);
      });


     // emit(course_state());
    }

  }

  FutureOr<void> watch_void(watch_event event, Emitter<MainState> emit) {
    emit(watch_state(event.part));
  }

  Future<FutureOr<void>> init_porfile1_void(init_porfile1 event, Emitter<MainState> emit) async {
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
        emit(init_porfile_state());
        //print(user_model?.id);
        // cache.save_data("id", user_model?.id);
        // emit(scss_login(user_model?.name));
      }
    });
  }

  Future<FutureOr<void>> init_porfile2_void(init_porfile2 event, Emitter<MainState> emit) async {
    course_list.clear();
    emit(loading_porfile_state());
   await dio.get_data(url: "/index/my_course",quary: {"user_id":cache.get_data("id"),"is_course":event.type}).then((value) {
     print(value?.data);
     if(value?.data[0].length==0){
       emit(empty_profile_state());
     }else {
       value?.data[0].forEach((e){
       course_list.add(course_module.fromjson(e));
       if(value.data[0].indexOf(e)+1 == course_list.length){
         emit(init_porfile_state());
       }
     });
     }
   });
  }

  void update_profile_index (int a){
    porfile_tab_index = a ;
    emit(profile_tab_state());
  }

  Future<FutureOr<void>> get_exam_void(get_exam_event event, Emitter<MainState> emit) async {
    await dio.get_data(url:"/index/exam",quary: {"subject":event.subject,"grade":event.grade}).then((value) {
      all_exam_list.clear();
      value?.data.forEach((element){
        all_exam_list.add(element);
        if(all_exam_list.length == value.data.indexOf(element)+1){
          emit(get_exam_state());
        }
      });
    });
  }

  Future<FutureOr<void>> get_file_void(get_file_event event, Emitter<MainState> emit) async {
    try{
      await dio.get_data(url:"/index/file",quary: {
        "subject":event.subject,
        "grade":event.grade,
        "teacher_name":event.teacher,
      }).then((value) {
        print(value?.data);
        all_file_list.clear();
        // print(value?.data);
        // print(event.subject);
        // print(event.grade);
        // print(event.teacher);
        value?.data.forEach((e){
          // course_list.add(course_module.fromjson(e));
          // teacher_list.add(teacher_module.fromjson(e));
          all_file_list.add(e);
        });

      });
    }catch(e){

    }finally{
      emit(course_state());
    }
  }

  Future<FutureOr<void>> get_file_details_void(get_file_details_event event, Emitter<MainState> emit) async {
    try{
      await dio.get_data(url:"/index/my_file",quary: {
        "subject":event.subject,
        "grade":event.grade,
        "teacher_name":event.teacher,
        "file":event.file,
        "user_id":cache.get_data("id"),
        "is_course":0,
      }).then((value) {
         print(value?.data);
        if(value?.data=="notfound"){
          emit(not_sub_file_state());
          print("okada");
        }else {
          // value?.data.forEach((e){
          //   part_list.add(part_module.fromjson(e));
          // });
          emit(get_file_link_state(value?.data[0]["link"]));
        }

        // value?.data.forEach((e){
        // //  course_list.add(course_module.fromjson(e));
        //   // teacher_list.add(teacher_module.fromjson(e));
        // });

      });
    }catch(e){
      print(e);
    }finally{
      // print(part_list[0].name);
      // print(part_list[0].part?[0].name);
      // print(part_list[0].part?[0].res);
      // part_list.forEach((element) {
      //   part_tab_list.add(element.name!);
      // });

     // emit(sub_state());
      // emit(course_state());
    }
  }


}
