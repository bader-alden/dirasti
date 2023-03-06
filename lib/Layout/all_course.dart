import 'package:dirasti/Layout/courses_details.dart';
import 'package:dirasti/module/course_module.dart';
import 'package:dirasti/module/teacher_module.dart';
import 'package:dirasti/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Bloc/main/main_bloc.dart';
import '../module/subject_module.dart';

class AllCourse extends StatelessWidget {
  const AllCourse({Key? key, required this.subject, required this.teacher}) : super(key: key);
  final subject_module subject;
final teacher_module teacher;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) => MainBloc()..add(get_course_event(subject.grade,subject.id,teacher.id)),
  child: BlocConsumer<MainBloc, MainState>(
  listener: (context, state) {
    // TODO: implement listener
  },
  builder: (context, state) {
    return Scaffold(
        appBar: appbar_back("مادة "+subject.subject!),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(height: 30,),
            Center(
              child: CircleAvatar(
                radius: 75,
              ),
            ),
            SizedBox(height: 15,),
            Center(child: Text(teacher.teacher_name??"اسم الاستاذ",style: TextStyle(fontSize: 24),),),
            SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("جميع الكورسات",style: TextStyle(fontSize: 24,color: orange,fontWeight: FontWeight.bold),),
                SizedBox(width: 20,)
              ],
            ),
            SizedBox(height: 15,),

            Expanded(child: ListView.builder(
                shrinkWrap: true,
                itemCount: context.read<MainBloc>().course_list.length,
                itemBuilder: (context,index){
              return course_item(context,index,context.read<MainBloc>().course_list[index]);
            }))
          ],
        ),
      );
  },
),
);
  }

  Widget course_item(BuildContext context, int index, course_module model) {
    return Card(
      child: SizedBox(
        height: 270,
        //  width: MediaQuery.of(context).size.width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(height: 10,),
                  Text(model.name??"اسم الكورس",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22)),
                  SizedBox(height: 5),
                  Text("السعر "+model.price!,style: TextStyle(color: orange,fontSize: 18)),
                  SizedBox(height: 5,),
                  Row(
                    children: [
                      Text(" ساعة "),
                      Text(model.number_hours??"00 "),
                      Icon(Icons.timelapse),
                      SizedBox(width: 10,),
                      Text(" درس "),
                      Text(model.part??"00"),
                      Icon(Icons.play_arrow)
                    ],
                  ),
                  SizedBox(height: 10,),
                  SizedBox(width: MediaQuery.of(context).size.width-200,child: Text("نفاصيلx "*10,textDirection: TextDirection.rtl,overflow: TextOverflow.ellipsis,maxLines: 3,)),
                  Spacer(),
                  SizedBox(
                    height: 40,
                    width: MediaQuery.of(context).size.width-200,
                    child: Row(
                      children: [
                        Container(child: FilledButton(onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>CoursesDetails(subject: subject,teacher: teacher,course: model,)));
                        }, child: Text("عرض نفاصيل"),style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(blue)),)),
                        Spacer(),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                ],
              ),
            ),
            SizedBox(width: 20,),
            SizedBox(height:280,width:150,child:Image.asset("assets/img_1.png",height: 280,fit: BoxFit.fitHeight,)),

          ],
        ),
      ),
    );
  }
}
