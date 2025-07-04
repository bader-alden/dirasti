import 'package:dirasti/Layout/all_exam.dart';
import 'package:dirasti/Layout/teacher_course.dart';
import 'package:dirasti/module/subject_module.dart';
import 'package:dirasti/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

import '../Bloc/main/main_bloc.dart';

class Subject_type extends StatelessWidget {
  const Subject_type({Key? key, this.hero, required this.subject}) : super(key: key);
  final hero;
  final subject_module subject;
  @override
  Widget build(BuildContext context) {
    // FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    return
      Hero(
        tag: hero.toString(),
        child: Material(
          child: Scaffold(
              backgroundColor:  white,
            appBar: appbar_back("مادة "+subject.subject!),
            body: Column(
              children: [
                  SizedBox(height: 30,),
                  banner_widget(subject.type_banner!),
                  SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("تريده",textDirection: TextDirection.rtl,style: TextStyle(color: orange,fontSize: 25,fontWeight: FontWeight.bold)),
                    SizedBox(width: 5,),
                    Text("اختر القسم الذي",textDirection: TextDirection.rtl,style: TextStyle(color: blue,fontSize: 25,fontWeight: FontWeight.bold)),
                    SizedBox(width: 35,),
                  ],
                ),
                SizedBox(height: 0,),
            Expanded(child: Column(
              children: [
                _subject_type_list_item("الكورسات",0,()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>TeacherCourse(subject:subject,type:"course" )))),
                _subject_type_list_item("الورقيات",1,()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>TeacherCourse(subject:subject,type:"file" )))),
                // _subject_type_list_item("الإختبارات",2,()=>Navigator.push(context, MaterialPageRoute(builder: (context)=> AllExam(subject: subject,)))),
                _subject_type_list_item("الإختبارات",2,()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>TeacherCourse(subject:subject,type:"exam" )))),
              ],
            )),
                SizedBox(height: 30,),
              ],
            )
          ),
        ),
      );
  }
}

Widget _subject_type_list_item (String text,index,Function() ontap){
  return Expanded(child: Padding(
    padding: EdgeInsets.all(10),
    child: InkWell(
      radius: 20,
      borderRadius: BorderRadius.circular(20),
      onTap: ontap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Center(child: Row(
          children: [
            Image.asset("assets/img_2.png",fit: BoxFit.fitHeight,height: double.infinity),
            Spacer(),
            Text(text,style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold)),
            SizedBox(width: 50,),
            if(index == 0)CircleAvatar(backgroundColor: blue,radius: 25,child: Image.asset("assets/img.png",height: 30,),),
            if(index == 1)CircleAvatar(backgroundColor: blue,radius: 25,child: Image.asset("assets/file.png",height: 30,),),
            if(index == 2)CircleAvatar(backgroundColor: blue,radius: 25,child: Image.asset("assets/exam.png",height: 30,),),
            SizedBox(width: 30),
          ],
        )),
      ),
    ),
  ));
}
