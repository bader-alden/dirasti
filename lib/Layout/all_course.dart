import 'package:dirasti/Layout/courses_details.dart';
import 'package:dirasti/module/course_module.dart';
import 'package:dirasti/module/teacher_module.dart';
import 'package:dirasti/utils/const.dart';
import 'package:dirasti/utils/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../Bloc/main/main_bloc.dart';
import '../module/subject_module.dart';

class AllCourse extends StatelessWidget {
  const AllCourse({Key? key, required this.subject, required this.teacher}) : super(key: key);
  final subject_module subject;
final teacher_module teacher;
  @override
  Widget build(BuildContext context) {
    // FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    return BlocProvider(
  create: (context) => MainBloc()..add(get_course_event(subject.grade,subject.id,teacher.id)),
  child: BlocConsumer<MainBloc, MainState>(
  listener: (context, state) {
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
                backgroundColor: Colors.transparent,
                child: Image.network(teacher.photo!,height: 150,),
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
              physics: BouncingScrollPhysics(),
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Card(
        child: SizedBox(
          height: 300,
          //  width: MediaQuery.of(context).size.width,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(height:300,width:150,child:Image.network(model.photo!,height: 280,fit: BoxFit.fitHeight,)),
              SizedBox(width: 15,),
              Container(
                width:MediaQuery.of(context).size.width-170 ,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(height: 10,),
                    Text(model.name??"اسم الكورس",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22),maxLines: 2,),
                    SizedBox(height: 5),
                      if( model.price=="0")
                      Text(
                        "كورس مجاني",
                        style: TextStyle(color: orange,fontSize: 18),
                      )
                    else
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
                    SizedBox(width: MediaQuery.of(context).size.width-200,child: Text(model.des!,textDirection: TextDirection.rtl,overflow: TextOverflow.ellipsis,maxLines: 3,)),
                    Spacer(),
                    SizedBox(
                      height: 40,
                      width: MediaQuery.of(context).size.width-200,
                      child: Row(
                        children: [
                          Container(child: FilledButton(onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>CoursesDetails(course: model,)));
                          }, child: Text("عرض تفاصيل"),style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(blue)),)),
                          Spacer(),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                  ],
                ),
              ),



            ],
          ),
        ),
      ),
    );
  }
}
