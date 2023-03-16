import 'package:dirasti/module/subject_module.dart';
import 'package:dirasti/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Bloc/exam/exam_bloc.dart';

class ExamDetails extends StatelessWidget {
  const ExamDetails({Key? key, this.exam, required this.subject, this.exam_name}) : super(key: key);
final exam;
final subject_module subject;
final exam_name;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExamBloc()..add(init_event(subject.grade, subject.id, exam)),
      child: BlocConsumer<ExamBloc, ExamState>(
        listener: (context, state) {
          if(state is check_state){
            showDialog(context: context, builder: (contexta)=>AlertDialog(
              title: Column(
                children: [
                  Text("عدد الاجابات الصحيحة" + (context.read<ExamBloc>().correct_answer.length -context.read<ExamBloc>().wrong_answer.length).toString()),
                  Text("عدد الاجابات الغلط" + (context.read<ExamBloc>().wrong_answer.length).toString())
                ],
              ),
            ));
          }
        },
        builder: (context, state) {
          return Scaffold(
              appBar: appbar_back(exam_name),
              body: Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: Container(
                          color: white,
                          width: double.infinity,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          color: blue,
                          width: double.infinity,
                        ),
                      ),
                    ],
                  ),
                  if(context.read<ExamBloc>().all_q.isEmpty)
                    Container(color: Colors.white,height:double.infinity,width: double.infinity,child: Center(child: SizedBox(width: 50,height: 50,child: CircularProgressIndicator())),)
                  else
                  ListView(
                    physics: BouncingScrollPhysics(),
                    children: [
                      Container(
                        color: white,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: 4,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(7.0),
                                child: Card(
                                  elevation: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          children: [
                                            Spacer(),
                                            if(context.read<ExamBloc>().wrong_answer[index] !=null)
                                              Icon(Icons.close,color: Colors.red,size: 50,)
                                            else if (context.read<ExamBloc>().correct_answer[index] !=null)
                                              Icon(Icons.check,color: Colors.green,size: 50),
                                            Spacer(),
                                            Text(
                                              "السؤال " + (index + 1).toString() + " : ", textDirection: TextDirection.rtl,
                                              style: TextStyle(fontSize: 18),),
                                          ],
                                        ),
                                        Text(context.read<ExamBloc>().all_q[index].question!, textDirection: TextDirection.rtl,style: TextStyle(fontSize: 18),),
                                        SizedBox(height: 5,),
                                        Row(
                                          children: [
                                            Spacer(),
                                            Text(context.read<ExamBloc>().all_q[index].Answer1!),
                                            SizedBox(width: 5,),
                                            CircleAvatar(radius: 5,backgroundColor: Colors.black,),
                                            SizedBox(width: 5,),
                                          ],
                                        ),
                                        SizedBox(height: 5,),
                                        Row(
                                          children: [
                                            Spacer(),
                                            Text(context.read<ExamBloc>().all_q[index].Answer2!),
                                            SizedBox(width: 5,),
                                            CircleAvatar(radius: 5,backgroundColor: Colors.black,),
                                            SizedBox(width: 5,),
                                          ],
                                        ),
                                        SizedBox(height: 5,),
                                        Row(
                                          children: [
                                            Spacer(),
                                            Text(context.read<ExamBloc>().all_q[index].Answer3!),
                                            SizedBox(width: 5,),
                                            CircleAvatar(radius: 5,backgroundColor: Colors.black,),
                                            SizedBox(width: 5,),
                                          ],
                                        ),
                                        SizedBox(height: 5,),
                                        Row(
                                          children: [
                                            Spacer(),
                                            Text(context.read<ExamBloc>().all_q[index].Answer4!),
                                            SizedBox(width: 5,),
                                            CircleAvatar(radius: 5,backgroundColor: Colors.black,),
                                            SizedBox(width: 5,),
                                          ],
                                        ),
                                        SizedBox(height: 20,),
                                        Row(
                                          children: [
                                            Spacer(),
                                            answer_item(4,context,index),
                                            Spacer(),
                                            Container(
                                              width: 2,
                                              height: 25,
                                              color: Colors.grey.shade300,
                                            ),
                                            Spacer(),
                                            answer_item(3,context,index),
                                            Spacer(),
                                            Container(
                                              width: 2,
                                              height: 25,
                                              color: Colors.grey.shade300,
                                            ),
                                            Spacer(),
                                            answer_item(2,context,index),
                                            Spacer(),
                                            Container(
                                              width: 2,
                                              height: 25,
                                              color: Colors.grey.shade300,
                                            ),
                                            Spacer(),
                                            answer_item(1,context,index),
                                            Spacer(),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                      InkWell(
                        onTap: (){
                          context.read<ExamBloc>().add(check_event());
                        },
                        overlayColor: MaterialStatePropertyAll(Colors.transparent),
                        child: Container(
                          height: 100,
                          width: 200,
                          color: blue,
                          child: Center(
                            child: Text("إنهاء الامتحان", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white)),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              )
          );
        },
      ),
    );
  }

 Widget answer_item(int i,BuildContext context,index) {
   return TextButton(style:ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.transparent)),onPressed: ()=>context.read<ExamBloc>().add(shoose_event(index, i)),child: Text("الاختيار " + (i).toString(), style: TextStyle(color:
   context.read<ExamBloc>().correct_answer[index] == i ? Colors.green:context.read<ExamBloc>().wrong_answer[index] == i?Colors.red:Colors.black,


       fontWeight:context.read<ExamBloc>().all_answer[index] == i ?FontWeight.bold: FontWeight.normal),));
  }
}
