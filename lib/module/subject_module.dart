class subject_module{
  String? id;
  String? photo;
  String? subject;
  String? grade;
  subject_module.fromjson(json){
    id = json['id'].toString();
    photo = json['photo'].toString();
    subject = json['subject'].toString();
    grade = json['grade'].toString();
  }
}