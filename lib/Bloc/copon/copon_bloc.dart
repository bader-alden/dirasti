import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dirasti/module/copon_module.dart';
import 'package:dirasti/utils/cache.dart';
import 'package:dirasti/utils/dio.dart';
import 'package:meta/meta.dart';

part 'copon_event.dart';
part 'copon_state.dart';

class CoponBloc extends Bloc<CoponEvent, CoponState> {
  CoponBloc() : super(CoponInitial()) {
    on<serch_copon_event>(serch_copon_void);
    on<change_state_event>(change_state_void);
    on<add_state_event>(add_copon_void);
  }
  Future<FutureOr<void>> serch_copon_void(serch_copon_event event, Emitter<CoponState> emit) async {
    emit(src_loading());
    await dio.get_data(url: "/copons",quary: {"uid_copon":event.copon,"grade":"0"}).then((value) {
      print(value?.data);
      if(value?.data=="notfound"){
        emit(not_found());
      }else if (value?.data=="error10"){
        emit(not_match_grade());
      }
        else{

        copon_module copon = copon_module.fromjson(value?.data[0]);
        if(copon.is_open!){
          emit(found(copon));
        }else{
          emit(not_open());
        }
      }
    });
  }


  FutureOr<void> change_state_void(change_state_event event, Emitter<CoponState> emit) {
    emit(change_state(copon_module.fromjson(event.copon)));
  }

  Future<FutureOr<void>> add_copon_void(add_state_event event, Emitter<CoponState> emit) async {
    emit(add_loading());
    await dio.post_data(url: "/copons",quary: {"uid_copon":event.copon,"user_id":cache.get_data("id")}).then((value) {
      print(value?.data);
      if(value?.data=="ok"){
        emit(scss());
      }else{
        emit(error());
      }
    });


  }
}
