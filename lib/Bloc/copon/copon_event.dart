part of 'copon_bloc.dart';

@immutable
abstract class CoponEvent {}
class serch_copon_event extends CoponEvent{
  final copon;

  serch_copon_event(this.copon);
}
class change_state_event extends CoponEvent{
  final copon;

  change_state_event(this.copon);
}
class add_state_event extends CoponEvent{
  final copon;

  add_state_event(this.copon);
}
