import 'package:dirasti/utils/const.dart';
import 'package:flutter/material.dart';

class Setting extends StatelessWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        actions: [
          Text("الإعدادات",style: TextStyle(color: blue,fontSize: 27),),
          SizedBox(width: 10,),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 10,),
          setting_item("أماكن بيع أكواد التفعيل",Icons.location_on_outlined),
          setting_item("سياسة الخصوصية",Icons.my_library_books_outlined),
          setting_item("أسئلة مكررة",Icons.question_answer_outlined),
          setting_item("التواصل الاجتماعي",Icons.smartphone_outlined),
          setting_item("التواصل  مع الدعم الفني",Icons.support_agent),
        ],
      ),
    );
  }
}
Widget setting_item(String text,IconData icon,){
  return  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
    child: InkWell(
      overlayColor: MaterialStatePropertyAll(Colors.transparent),
      onTap: (){},
      child: Row(
        children: [
          SizedBox(width: 20,),
          Icon(Icons.arrow_back_ios_new),
          Spacer(),
          Text(text,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
          SizedBox(width: 40,),
          Card(elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(icon,color: blue),
              )),
          SizedBox(width: 20,),
        ],
      ),
    ),
  );
}
