import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dirasti/module/course_module.dart';
import 'package:dirasti/module/part_module.dart';
import 'package:dirasti/module/subject_module.dart';
import 'package:dirasti/utils/cache.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:dirasti/utils/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';
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
    on<get_exam_details_event>(get_exam_details_void);
    on<watch_event>(watch_void);
    on<get_exam_event>(get_exam_void);
    on<get_file_event>(get_file_void);
    on<search_event>(search_void);
    on<logs_event>(logs_void);
  }
  user_module? user_model;
  List<subject_module> subject_list=[];
  List<teacher_module> teacher_list=[];
  List<course_module> course_list=[];
  List<part_module> part_list=[];
  List<String> logs_list=[];
  List<String> part_tab_list=[];
  List<Map> all_file_list=[];
  List<Map<String,dynamic>> all_exam_list=[];
  int porfile_tab_index=1;
  String main_banner_image="";
  Future<FutureOr<void>> init_void(init event, Emitter<MainState> emit) async {
    try{
      await dio.post_data(url:"/index/login_id",quary: {
        //"user_id":cache.get_data("id"),
        "secret_code":cache.get_data("scode"),
      }).then((value)async{
        if(value?.data == "error1"){
          // emit(error_login("تم تسجيل الدخول من جوال اخر"));
        }else if(value?.data == "error2"){
          //  emit(error_login("غير موجود"));
        }else{
          user_model= user_module.fromjson(value?.data[0]);
          //print(user_model?.id);
          // cache.save_data("id", user_model?.id);
          // emit(scss_login(user_model?.name));
        }
      }).catchError((e){
      });

      await dio.get_data(url: "/index/banner").then((value) {
        main_banner_image = value?.data[0]["banner"];
      });
      subject_list.clear();
      await dio.get_data(url: "/index/subject").then((value) {
        value?.data.forEach((e){
          subject_list.add(subject_module.fromjson(e));
        });
      });

    }catch (e){
    }
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
        value?.data.forEach((e){
          teacher_list.add(teacher_module.fromjson(e));
          sec_teacher_list.add(teacher_module.fromjson(e));
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
        value?.data.forEach((e){
          course_list.add(course_module.fromjson(e));
         // teacher_list.add(teacher_module.fromjson(e));
        });

      });
    }catch(e){

    }finally{
      course_list.sort((a, b) => a.order!.compareTo(b.order!),);
      emit(course_state());
    }
  }

  Map<int,List<int>> video_index_map  = {};

  Future<FutureOr<void>> get_course_details_void(get_course_details_event event, Emitter<MainState> emit) async {
    try{
      await dio.get_data(url:"/index/user_logs").then((value) {
        print(value?.data);
        if(value?.data![0]['logs']!= "" &&value!.data[0]['logs'].toString().split(",").length>1){
          logs_list = value.data[0]['logs'].toString().split(",");
        }
      });
      await dio.get_data(url:"/index/part",quary: {
        "subject":event.subject,
        "grade":event.grade,
        "teacher_name":event.teacher,
        "course":event.course,
       // "user_id":cache.get_data("id"),
        "is_course":1,
      }).then((value) {
        video_index_map.clear();
        part_list.clear();
        part_tab_list.clear();
        int ind = 0;
       // print(value?.data);
        if(value?.data=="notfound"){
          emit(not_sub_state());
        }else{
          value?.data.forEach((e){
            part_list.add(part_module.fromjson(e));
          });
          // part_list = part_list.reversed.toList();
          part_list.sort((a, b) => a.order!.compareTo(b.order!),);

          part_list.forEach((element) {
            element.part?.sort((a, b) => a.order!.compareTo(b.order!));
            part_tab_list.add(element.name!);
            element.part?.forEach((element2) {
              //print(element.name! +"    " + element2.name!);
              //print(ind);
              if(video_index_map[part_list.indexOf(element)] == null){
                video_index_map[part_list.indexOf(element)]=[];
              }
             // video_index_map[part_list.indexOf(element)]=[];
              video_index_map[part_list.indexOf(element)]?.add(ind++);
            });
          });

          // print(video_index_map);
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
     // part_list.sort((a, b) => a.order!.compareTo(b.order!),);
      // print(part_list[0].name);
      // print(part_list[0].part?[0].name);
     // print(part_list[0].part?[0].res);
     // emit(course_state());
    }

  }

  FutureOr<void> watch_void(watch_event event, Emitter<MainState> emit) {
    emit(watch_state(event.part));
  }

  Future<FutureOr<void>> init_porfile1_void(init_porfile1 event, Emitter<MainState> emit) async {
    await dio.post_data(url:"/index/login_id",quary: {
   //   "user_id":cache.get_data("id"),
      "secret_code":cache.get_data("scode"),
    }).then((value){
      print("0000");
      print(value?.data);
      print("0000");
      if(value?.data == "error1"){
        // emit(error_login("تم تسجيل الدخول من جوال اخر"));
      }else if(value?.data == "error2"){
        //  emit(error_login("غير موجود"));
      }else{
        user_model= user_module.fromjson(value?.data[0]);
        emit(init_porfile_state());
        //print(user_model?.id);
        // cache.save_data("id", user_model?.id);
        // emit(scss_login(user_model?.name));
      }
    });
  }
  List<Map> my_file_list=[];
  Future<FutureOr<void>> init_porfile2_void(init_porfile2 event, Emitter<MainState> emit) async {
    course_list.clear();
    my_file_list.clear();
    emit(loading_porfile_state());
   await dio.get_data(url: "/index/my_course",quary: {
    // "user_id":cache.get_data("id"),
     "is_course":event.type}).then((value) {
     if(value?.data =='notfound10'||value?.data[0].length==0 || value?.data ==' '){
       emit(empty_profile_state());
     }else {
       value?.data[0].forEach((e){
         if(event.type == 1) {
           course_list.add(course_module.fromjson(e));
         }else{
           my_file_list.add(e);
         }
       if(value.data[0].indexOf(e)+1 == course_list.length ||value.data[0].indexOf(e)+1 == my_file_list.length){
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
    await dio.get_data(url:"/index/exam",quary: {"subject":event.subject,"grade":event.grade,"teatcher":event.teatcher}).then((value) {
      all_exam_list.clear();
      value?.data.forEach((element){
        all_exam_list.add(element);
        if(all_exam_list.length == value.data.indexOf(element)+1){
          all_file_list.sort((a, b) => a['ordero'].toString().compareTo(b['ordero'].toString()));
          emit(get_exam_state());
        }
      });
    });
  }
  void check_version (){
    print("start check");
    dio.get_data(url: "/data/version").then((value) async {
      PackageInfo.fromPlatform().then((valuee) {
        if(value?.data[0]['version']==valuee.version){
        }else{
          emit(not_match_version(value?.data[0]['link']));
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
      all_file_list.sort((a, b) => a['ordero'].toString().compareTo(b['ordero'].toString()));
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
       // "user_id":cache.get_data("id"),
        "is_course":0,
      }).then((value) {
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
  Future<FutureOr<void>> get_exam_details_void(get_exam_details_event event, Emitter<MainState> emit) async {
    try{
      await dio.get_data(url:"/index/my_exam",quary: {
        "subject":event.subject,
        "grade":event.grade,
        "teacher_name":event.teacher,
        "exam":event.exam,
        // "user_id":cache.get_data("id"),
        "is_course":2,
      }).then((value) {
        if(value?.data=="notfound"){
          emit(not_sub_exam_state());
          print("okada");
        }else {
          // value?.data.forEach((e){
          //   part_list.add(part_module.fromjson(e));
          // });
          emit(get_exam_link_state());
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
  List<teacher_module> serarch_list= [];
  List<teacher_module> sec_teacher_list= [];


  FutureOr<void> search_void(search_event event, Emitter<MainState> emit) {
     serarch_list = teacher_list;

    final suge = serarch_list.where((element) {
      final title = element.teacher_name!.toLowerCase();
      final input = event.query.toLowerCase();
      return title.contains(input);
    }).toList();

    teacher_list = suge;
    emit(serch_state());
  }
  void restore_list(){
    teacher_list = sec_teacher_list;
    emit(serch_state());
  }

  FutureOr<void> logs_void(logs_event event, Emitter<MainState> emit) {
    if(!logs_list.contains(event.name)){
      logs_list.add(event.name);
      dio.post_data(url: "/index/user_logs",quary: {"data":event.name+","});
      print("object "*20);
      logs_list.forEach((element) {print(element); });
     // emit(logs_state());
    }
  }
}
