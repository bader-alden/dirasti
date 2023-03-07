part of 'main_bloc.dart';

@immutable
abstract class MainEvent {}
class init extends MainEvent{}
class init_porfile1 extends MainEvent{}
class init_porfile2 extends MainEvent{
  final type;

  init_porfile2(this.type);
}
class get_teatcher_event extends MainEvent{
  final name;
  final grade;

  get_teatcher_event(this.name, this.grade);
}
class get_course_event extends MainEvent{
  final subject;
  final grade;
  final teacher;

  get_course_event( this.grade, this.subject, this.teacher);
}
class get_course_details_event extends MainEvent{
  final subject;
  final grade;
  final teacher;
  final course;

  get_course_details_event( this.grade, this.subject, this.teacher,this.course);
}

class watch_event extends MainEvent{
  final part;

  watch_event( this.part,);
}
class get_exam_event extends MainEvent{
  final grade ;
  final subject ;

  get_exam_event(this.grade, this.subject);

}