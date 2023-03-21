import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dirasti/module/q_module.dart';
import 'package:dirasti/utils/dio.dart';
import 'package:meta/meta.dart';

part 'exam_event.dart';
part 'exam_state.dart';

class ExamBloc extends Bloc<ExamEvent, ExamState> {
  ExamBloc() : super(ExamInitial()) {
    on<init_event>(init_void);
    on<shoose_event>(shoose_void);
    on<check_event>(check_void);
  }
List<q_module> all_q=[];
Map<int,int> all_answer={};
Map<int,int> wrong_answer={};
Map<int,int> correct_answer={};
  Future<FutureOr<void>> init_void(init_event event, Emitter<ExamState> emit) async {
    all_q.clear();
    await dio.get_data(url: "/index/all_tests",quary: {
      "subject":event.subject,
      "grade":event.grade,
      "exam":event.exam,
    }).then((value) {
      value?.data.forEach((e){
        all_q.add(q_module.fromjson(e));
        if(all_q.length==value?.data.indexOf(e)+1){
          emit(init_state());
        }
      });

    });
  }

  FutureOr<void> shoose_void(shoose_event event, Emitter<ExamState> emit) {
    all_answer[event.first]=event.sec;
    emit(shoose_state());
  }

  FutureOr<void> check_void(check_event event, Emitter<ExamState> emit) {
    // if(all_answer.length!=all_q.length){
    //   print("not all ");
    // }else{
      all_answer.forEach((key, value) {
        if(all_q[key].index==value.toString()){
          correct_answer[key]=value;
        }else{
          wrong_answer[key]=value;
          correct_answer[key]=int.parse(all_q[key].index!);
        }

      });
    all_q.forEach((element) {
      if(wrong_answer.containsKey(all_q.indexOf(element))||correct_answer.containsKey(all_q.indexOf(element))){
      }else{
        wrong_answer[all_q.indexOf(element)]=5;
        correct_answer[all_q.indexOf(element)]=int.parse(element.index!)-1;
      }
    });
      emit(check_state());


  }
}
