class calendar_module{
  String? body;
  String? date;
  String? time;
  String? id;
  String? subject;
  calendar_module.fromjson(json){
    body = json['body'];
    date = json['date'];
    id = json['id'].toString();
    time = json['time'];
    subject = json['subject'];
  }
}