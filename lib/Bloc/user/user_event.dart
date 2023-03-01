part of 'user_bloc.dart';

@immutable
abstract class UserEvent {}
class user_signin extends UserEvent{
  final String name;
  final String email;
  final String mobile_id;
  final String grade;
  final int is_male;
  user_signin(this.name, this.email, this.mobile_id, this.is_male,this.grade);
}

class user_init extends UserEvent{
  final String id;

  user_init(this.id);
}
class grade_init extends UserEvent{}
class user_login extends UserEvent{
  final String num ;

  user_login(this.num);
}