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
class updeate_event extends CalendarEvent{
  final id;
  final date;
  final time;
  final subject;
  final body;

  updeate_event(this.id , this.date, this.time, this.subject, this.body);
}
class delete_event extends CalendarEvent{
  final id ;
  final date ;

  delete_event(this.id,this.date);
}