part of 'main_bloc.dart';

@immutable
abstract class MainState {}

class MainInitial extends MainState {}

class init_state extends MainInitial {}
class logs_state extends MainInitial {}

class init_porfile_state extends MainInitial {}
class loading_porfile_state extends MainInitial {}
class empty_profile_state extends MainInitial {}
class profile_tab_state extends MainInitial {}
class teacher_state extends MainInitial {}
class course_state extends MainInitial {}
class not_sub_state extends MainInitial {}
class not_sub_file_state extends MainInitial {}
class sub_state extends MainInitial {}
class serch_state extends MainInitial {}
class not_match_version extends MainInitial {
  final link;

  not_match_version(this.link);
}
class get_exam_state extends MainInitial {}

class not_sub_exam_state extends MainInitial {}
class get_exam_link_state extends MainInitial {}

class get_file_link_state extends MainInitial {
  final link ;

  get_file_link_state(this.link);

}
class watch_state extends MainInitial {
  final part;

  watch_state(this.part);
}
