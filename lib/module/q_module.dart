class q_module{
  String? question;
  String? Answer1;
  String? Answer2;
  String? Answer3;
  String? Answer4;
  String? index;
  String? photo;
  q_module.fromjson(json){
    question = json['question'];
    index = json['indexs'].toString();
    Answer1 = json['Answer1'].toString();
    Answer2 = json['Answer2'].toString();
    Answer3 = json['Answer3'].toString();
    Answer4 = json['Answer4'].toString();
    photo = json['photo'].toString();
    //print(photo == null);
    //print(photo == "");
  }
}