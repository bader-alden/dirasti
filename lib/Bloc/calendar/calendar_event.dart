part of 'calendar_bloc.dart';

@immutable
abstract class CalendarEvent {}
class init_event extends CalendarEvent{
  final date;

  init_event(this.date);
}
class get_event extends CalendarEvent{
  final date;

  get_event(this.date);
}
class insert_event extends CalendarEvent{
  final date;
  final time;
  final subject;
  final body;

  insert_event(this.date, this.time, this.subject, this.body);
}
class updeate_event extends CalendarEvent{}
class delete_event extends CalendarEvent{}