class course_module{
  String? teacher_name;
  String? name;
  String? id;
  String? subject;
  String? photo;
  String? grade;
  String? price;
  String? banner;
  String? des;
  String? part;
  String? number_hours;
  String? is_course;
  String? order;
  course_module.fromjson(json){
    teacher_name = json['teacher_name'];
    name = json['name'];
    order = json['ordero'].toString();
    id = json['id'].toString();
    subject = json['subject'].toString();
    banner = json['banner'].toString();
    photo = json['photo'].toString();
    des = json['des'].toString();
    grade = json['grade'].toString();
    price = json['price'].toString();
    part = json['part'].toString();
    number_hours = json['number_hours'].toString();
    is_course = json['is_course'].toString();
  }
}