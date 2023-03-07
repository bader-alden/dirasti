import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dirasti/Bloc/main/main_bloc.dart';
import 'package:dirasti/utils/cache.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:sqflite/sqflite.dart';

import '../../module/calendar_module.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc() : super(CalendarInitial()) {
   on<init_event>(init_void);
   on<get_event>(get_void);
   on<insert_event>(insert_void);
  }
  static CalendarBloc get(context) => BlocProvider.of(context);
  List<calendar_module> all_data = [];
  Database? database;
  // creatdb(date,time) {
  //
  // }
  //
  // insertdb(body, time, date,subject) {
  //
  // }
  //
  // void getdata(database,date,time) {
  //
  // }

  // void updatedata(states, id) {
  //   database?.rawUpdate('UPDATE tasks SET state = ? WHERE id = ?', [states, id]);
  //   getdata(database);
  //   emit(db_update_state());
  // }
  //
  // void deletdata(id) {
  //   database?.rawDelete('DELETE FROM tasks WHERE id = ?', [id]);
  //   getdata(database);
  //   emit(db_delete_state());
  // }

  Future<FutureOr<void>> init_void(init_event event, Emitter<CalendarState> emit) async {
   await openDatabase(
      "database.db",
      version: 1,
      onCreate: (database, vesion) async {
        await database
            .execute(
            "CREATE TABLE tasks (id INTEGER PRIMARY KEY ,body TEXT, time TEXT, date TEXT, subject TEXT)")
            .then((value) => print("created"));
      },
      onOpen: (database) {
        print("db oppend");
        add(get_event(event.date));
      },
    ).then((value) {
      database = value;
      add(get_event(event.date));
      emit(db_init_state());
    });

  }

  Future<FutureOr<void>> get_void(get_event event, Emitter<CalendarState> emit) async {
   await database?.rawQuery("SELECT * FROM tasks WHERE date = ? ",[event.date]).then((value) {
      all_data.clear();
      var tasks = value;
      print(tasks);
      tasks.forEach((element) {
        all_data.add(calendar_module.fromjson(element));
      });
      print("get data");
      emit(db_insert_state());
    });

  }



  Future<FutureOr<void>> insert_void(insert_event event, Emitter<CalendarState> emit) async {
   await database?.transaction(
          (txn) async {
        txn.rawInsert(
          "INSERT INTO tasks(body, time, date, subject) VALUES('${event.body}', '${event.time}', '${event.date}', '${event.subject}')",
        );
      },
    ).then((value) {
      print("insert");
      add(get_event(event.date));
      // getdata(database,event.date);
      // emit(db_insert_state());
    });

  }
}
