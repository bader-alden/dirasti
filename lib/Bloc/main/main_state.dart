part of 'main_bloc.dart';

@immutable
abstract class MainState {}

class MainInitial extends MainState {}

class init_state extends MainInitial {}

class init_porfile_state extends MainInitial {}
class loading_porfile_state extends MainInitial {}
class empty_profile_state extends MainInitial {}
class profile_tab_state extends MainInitial {}
class teacher_state extends MainInitial {}
class course_state extends MainInitial {}
class not_sub_state extends MainInitial {}
class sub_state extends MainInitial {}
class watch_state extends MainInitial {
  final part;

  watch_state(this.part);
}
