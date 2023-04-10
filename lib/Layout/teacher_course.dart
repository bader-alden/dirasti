import 'package:dirasti/Bloc/main/main_bloc.dart';
import 'package:dirasti/Bloc/main/main_bloc.dart';
import 'package:dirasti/Layout/all_course.dart';
import 'package:dirasti/module/teacher_module.dart';
import 'package:dirasti/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

import '../module/subject_module.dart';
import 'all_file.dart';
var _teacher_con = TextEditingController();
class TeacherCourse extends StatelessWidget {
  const TeacherCourse({Key? key, required this.subject, this.type}) : super(key: key);
  final subject_module subject;
final type;
  @override
  Widget build(BuildContext context) {
    FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    return BlocProvider(
      create: (context) => MainBloc()..add(get_teatcher_event(subject.id,subject.grade)),
      child: BlocConsumer<MainBloc, MainState>(
        listener: (context, state) {

        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: white,
            appBar: appbar_back((type =="course"?"كورسات مادة ":"ملفات مادة ") + subject.subject!),
            body: Column(
              children: [
                SizedBox(height: 30,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(child: Row(
                    children: [
                      Expanded(child: TextFormField(
                        textDirection: TextDirection.rtl,
                        controller: _teacher_con,
                        decoration: InputDecoration(hintText: "بحث...", hintTextDirection: TextDirection.rtl, border: InputBorder.none),
                      onChanged: (value){
                          context.read<MainBloc>().restore_list();
                          context.read<MainBloc>().add(search_event(value));
                      },
                      )),
                      SizedBox(width: 20,),
                      Icon(Icons.search),
                      SizedBox(width: 20,),
                    ],
                  )),
                ),
                Expanded(
                  child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: context.read<MainBloc>().teacher_list.length,
                      itemBuilder: (context, index) {
                        return techer_course_list_item(context, index,context.read<MainBloc>().teacher_list[index],subject,type);
                      }),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

Widget techer_course_list_item(BuildContext context, int index,teacher_module model,subject,type) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        if(type == "course"){
          Navigator.push(context, MaterialPageRoute(builder: (context) => AllCourse(subject: subject,teacher: model,)));
        }else{
          Navigator.push(context, MaterialPageRoute(builder: (context) => AllFile(subject: subject,teacher: model,)));
        }
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(model.teacher_name??"اسم الاستاذ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21)),
                  // SizedBox(height: 7,),
                  // Text("وصف " * 5, style: TextStyle(color: Colors.grey, fontSize: 15), overflow: TextOverflow.ellipsis),
                ],
              ),
              SizedBox(width: 20),
              SizedBox(height: 100, width: 100, child: Image.network(model.photo!),),
              SizedBox(width: 20),
            ],
          ),
        ),
      ),
    ),
  );
}
