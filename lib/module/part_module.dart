import 'dart:convert';

class part_module{
  String? teacher_name;
  String? name;
  String? id;
  String? subject;
  String? grade;
  List<part_detail_module>? part=[];
  String? number_hours;
  String? is_course;
  part_module.fromjson(jsond){
    teacher_name = jsond['teacher_name'];
    name = jsond['name'];
    id = jsond['id'].toString();
    subject = jsond['subject'].toString();
    grade = jsond['grade'].toString();
    json.decode(jsond['part'].toString()).forEach((e){
     part?.add( part_detail_module.fromjson(e));
    });
  }

}
class part_detail_module{
  String? name;
  String? time;
  Map? res;
  part_detail_module.fromjson(json){
    name = json['name'].toString();
    time = json['time'].toString();
    res = json['res'].map((key, value) => MapEntry(key, value?.toString()));
  }
}