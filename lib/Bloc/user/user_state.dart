part of 'user_bloc.dart';

@immutable
abstract class UserState {}

class UserInitial extends UserState {}

class scss_signin extends UserState {}

class scss_login extends UserState {
  final name;

  scss_login(this.name);
}
class error_login extends UserState {
  final error ;

  error_login(this.error);
}
class error_signin extends UserState {
  final error ;

  error_signin(this.error);
}
class init_state extends UserState {
  final List string ;
  final List id ;

  init_state( this.string, this.id);
}
class scss_update_state extends UserState {}
class faile_update_state extends UserState {}