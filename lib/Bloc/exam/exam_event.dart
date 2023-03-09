part of 'exam_bloc.dart';

@immutable
abstract class ExamEvent {}
class init_event extends ExamEvent{
  final grade;
  final subject;
  final exam;

  init_event(this.grade, this.subject, this.exam);
}
class check_event extends ExamEvent{}
class shoose_event extends ExamEvent{
  final first;
  final sec;

  shoose_event(this.first, this.sec);
}