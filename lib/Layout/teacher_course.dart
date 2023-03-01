import 'package:dirasti/Layout/all_course.dart';
import 'package:dirasti/utils/const.dart';
import 'package:flutter/material.dart';

class TeacherCourse extends StatelessWidget {
  const TeacherCourse({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: appbar_back("كورسات مادة العلوم"),
      body: Column(
        children: [
          SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(child: Row(
              children: [
                Expanded(child: TextFormField(
                  textDirection: TextDirection.rtl,
                  decoration: InputDecoration(hintText: "بحث...",hintTextDirection: TextDirection.rtl,border: InputBorder.none),)),
                SizedBox(width: 20,),
                Icon(Icons.search),
                SizedBox(width: 20,),
              ],
            )),
          ),
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: 5,
                itemBuilder: (context,index){
                  return techer_course_list_item(context,index);
                }),
          ),
        ],
      ),
    );
  }
}

Widget techer_course_list_item(BuildContext context, int index) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>AllCourse()));
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                Text("اسم الاستاذ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
                SizedBox(height: 7,),
                Text("وصف "*5,style: TextStyle(color: Colors.grey,fontSize: 15),overflow: TextOverflow.ellipsis),
                ],
              ),
              SizedBox(width:20),
              SizedBox(height: 100,width:100,child: Placeholder(),),
              SizedBox(width:20),
            ],
          ),
        ),
      ),
    ),
  );
}
