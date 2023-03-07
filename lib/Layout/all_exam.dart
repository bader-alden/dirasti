import 'package:dirasti/module/subject_module.dart';
import 'package:dirasti/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Bloc/main/main_bloc.dart';

class AllExam extends StatelessWidget {
  const AllExam({Key? key, required this.subject}) : super(key: key);
  final subject_module subject;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainBloc()..add(get_exam_event(subject.grade, subject.id)),
      child: BlocConsumer<MainBloc, MainState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Scaffold(
            appBar: appbar_back(subject.subject),
            body: Column(
              children: [
                SizedBox(height: 30,),
                banner_widget(),
                SizedBox(height: 20),
                Expanded(child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(child: SizedBox(
                          height: 100,
                          child: Row(
                            children: [
                              SizedBox(width: 20,),
                              Center(
                                child: Container(padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: blue),
                                    child: Text("ابدأ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
                              ),
                              Spacer(),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text("اسم الاختبار", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                                  Text("30 دقيقة")
                                ],
                              ),
                              SizedBox(width: 10,),
                              Image.asset("assets/exam.png", height: 50,),
                              SizedBox(width: 20,),
                            ],
                          ),
                        ),),
                      );
                    }))
              ],
            ),
          );
        },
      ),
    );
  }
}
