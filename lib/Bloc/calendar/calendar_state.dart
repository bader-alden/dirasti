part of 'calendar_bloc.dart';

@immutable
abstract class CalendarState {}

class CalendarInitial extends CalendarState {}
class db_init_state extends CalendarState {}
class db_insert_state extends CalendarState {}
class db_update_state extends CalendarState {}
class db_delete_state extends CalendarState {}
