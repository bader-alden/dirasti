class subject_module{
  String? id;
  String? photo;
  String? subject;
  String? grade;
  String? type_banner;
  String? file_banner;
  String? exam_banner;
  subject_module.fromjson(json){
    id = json['id'].toString();
    photo = json['photo'].toString();
    subject = json['subject'].toString();
    grade = json['grade'].toString();
     type_banner = json['banner1'].toString();
     file_banner = json['banner2'].toString() ;
     exam_banner = json['banner3'].toString() ;
  }
}