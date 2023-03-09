part of 'copon_bloc.dart';

@immutable
abstract class CoponState {}

class CoponInitial extends CoponState {}
class not_found extends CoponState {}
class not_open extends CoponState {}
class found extends CoponState {
  final copon_module copon;

  found(this.copon);
}
class scss extends CoponState {}
class error extends CoponState {}
class src_loading extends CoponState {}
class add_loading extends CoponState {}
class added_before extends CoponState {}
class not_match_grade extends CoponState {}
class change_state extends CoponState {
  final c ;

  change_state(this.c);
}
