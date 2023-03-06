import 'package:dirasti/Bloc/main/main_bloc.dart';
import 'package:dirasti/Bloc/main/main_bloc.dart';
import 'package:dirasti/Layout/all_course.dart';
import 'package:dirasti/module/teacher_module.dart';
import 'package:dirasti/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../module/subject_module.dart';

class TeacherCourse extends StatelessWidget {
  const TeacherCourse({Key? key, required this.subject}) : super(key: key);
  final subject_module subject;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainBloc()..add(get_teatcher_event(subject.id,subject.grade)),
      child: BlocConsumer<MainBloc, MainState>(
        listener: (context, state) {

        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: white,
            appBar: appbar_back("كورسات مادة " + subject.subject!),
            body: Column(
              children: [
                SizedBox(height: 30,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(child: Row(
                    children: [
                      Expanded(child: TextFormField(
                        textDirection: TextDirection.rtl,
                        decoration: InputDecoration(hintText: "بحث...", hintTextDirection: TextDirection.rtl, border: InputBorder.none),)),
                      SizedBox(width: 20,),
                      Icon(Icons.search),
                      SizedBox(width: 20,),
                    ],
                  )),
                ),
                Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: context.read<MainBloc>().teacher_list.length,
                      itemBuilder: (context, index) {
                        return techer_course_list_item(context, index,context.read<MainBloc>().teacher_list[index],subject);
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

Widget techer_course_list_item(BuildContext context, int index,teacher_module model,subject) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => AllCourse(subject: subject,teacher: model,)));
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
                  Text(model.teacher_name??"اسم الاستاذ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  SizedBox(height: 7,),
                  Text("وصف " * 5, style: TextStyle(color: Colors.grey, fontSize: 15), overflow: TextOverflow.ellipsis),
                ],
              ),
              SizedBox(width: 20),
              SizedBox(height: 100, width: 100, child: Placeholder(),),
              SizedBox(width: 20),
            ],
          ),
        ),
      ),
    ),
  );
}
