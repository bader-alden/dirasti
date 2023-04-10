import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:dirasti/Bloc/bottom_nav/bottom_nav_bloc.dart';
import 'package:dirasti/Layout/calendar.dart';
import 'package:dirasti/module/subject_module.dart';
import 'package:dirasti/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import '../Bloc/exam/exam_bloc.dart';
DateTime?  times ;
CountdownTimerController? timer_con;
class ExamDetails extends StatelessWidget {
  const ExamDetails({Key? key, this.exam, required this.subject}) : super(key: key);
  final exam;
  final subject_module subject;
  @override
  Widget build(BuildContext context) {
    FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    if(times == null ){
      times = DateTime.now();
     timer_con  = CountdownTimerController(endTime: times!.add(Duration(seconds:int.parse(exam['time']) )).microsecondsSinceEpoch ~/ 1000);
    }
    return WillPopScope(
      onWillPop: () async {
        showDialog<void>(
          context: context,
          barrierDismissible: false, // false = user must tap button, true = tap outside dialog
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: Text('هل تريد فعلا الخروج من اللأختبار'),
              actions: <Widget>[
                TextButton(
                  child: Container(color: Colors.red,child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: Text('الخروج',style: TextStyle(color: Colors.white),)),
                  )),
                  onPressed: () {
                    times = null;
                    // timer_con?.dispose();
                    //  timer_con?.disposeTimer();
                    Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                    Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                  },
                ),
                TextButton(
                  child: Container(color: blue,child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: Text('البقاء',style: TextStyle(color: Colors.white),)),
                  )),
                  onPressed: () {
                    Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                  },
                ),
              ],
            );
          },
        );
        return await true;
      },
      child: BlocProvider(
        create: (context) => ExamBloc()..add(init_event(subject.grade, subject.id, exam['id'])),
        child: BlocConsumer<ExamBloc, ExamState>(
          listener: (context, state) {
            if (state is check_state) {
              showDialog(
                  context: context,
                  builder: (contexta) => AlertDialog(
                        title: Column(
                          children: [
                            Text("عدد الاجابات الصحيحة" +
                                (context.read<ExamBloc>().correct_answer.length - context.read<ExamBloc>().wrong_answer.length).toString()),
                            Text("عدد الاجابات الغلط" + (context.read<ExamBloc>().wrong_answer.length).toString())
                          ],
                        ),
                      ));
            }
          },
          builder: (context, state) {
            return Scaffold(
                appBar: appbar_back(exam['name']),
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
                    if (context.read<ExamBloc>().all_q.isEmpty)
                      Container(
                        color: Colors.white,
                        height: double.infinity,
                        width: double.infinity,
                        child: Center(child: SizedBox(width: 50, height: 50, child: CircularProgressIndicator())),
                      )
                    else
                      ListView(
                        physics: BouncingScrollPhysics(),
                        children: [
                          CountdownTimer(
                             controller:timer_con ,
                            // endTime:  DateTime.now().millisecondsSinceEpoch + 1000 * 190000000,
                            // endTime: times!.add(Duration(seconds:int.parse(exam['time']) )).microsecondsSinceEpoch ~/ 1000,
                            widgetBuilder: (_, CurrentRemainingTime? time) {
                               if(time?.sec == 1&&context.read<ExamBloc>().correct_answer.isEmpty){
                                 Future.delayed(Duration(seconds: 1)).then((value) => context.read<ExamBloc>().add(check_event()));
                               }
                              if (time == null) {
                                return Center(
                                  child: Text(
                                    'أنتهى الوقت',
                                    style: TextStyle(color: Colors.black,fontSize: 20),
                                  ),
                                );
                              }
                              if (time.days == null && time.hours == null && time.min == null) {
                                return Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: AnimatedFlipCounter(
                                    textStyle: TextStyle(color: Colors.black,fontSize: 20),
                                    duration: const Duration(seconds: 1),
                                    value: time.sec!.toInt(),
                                    prefix: "ثانية ",
                                    //  suffix: ثانية":"",
                                  ),
                                );
                                //return Text('${time.sec} '+context.read<LocaleBloc>().second,style: TextStyle(color: Colors.black,fontSize: 20),);
                              }
                              if (time.days == null && time.hours == null) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Directionality(
                                      textDirection: TextDirection.ltr,
                                      child: AnimatedFlipCounter(
                                        textStyle: TextStyle(color: Colors.black,fontSize: 20),
                                        duration: const Duration(seconds: 1),
                                        value: time.sec!.toInt(),
                                        prefix: "ثانية ",
                                        //    suffix: ثانية":"",
                                      ),
                                    ),
                                    Text(
                                      " : ",
                                      style: TextStyle(color: Colors.black,fontSize: 20),
                                    ),
                                    Directionality(
                                      textDirection: TextDirection.ltr,
                                      child: AnimatedFlipCounter(
                                        textStyle: TextStyle(color: Colors.black,fontSize: 20),
                                        duration: const Duration(seconds: 1),
                                        value: time.min!.toInt(),
                                        prefix: "دقيقة ",
                                        //    suffix: دقيقة":"",
                                      ),
                                    ),
                                  ],
                                );
                                //return Text('${time.min} دقيقة : ${time.sec} '+context.read<LocaleBloc>().second,style: TextStyle(color: Colors.black,fontSize: 20),);
                              }
                              if (time.days == null) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Directionality(
                                      textDirection: TextDirection.ltr,
                                      child: AnimatedFlipCounter(
                                        textStyle: TextStyle(color: Colors.black,fontSize: 20),
                                        duration: const Duration(seconds: 1),
                                        value: time.min!.toInt(),
                                        prefix: "دقيقة ",
                                        //      suffix: دقيقة":"",
                                      ),
                                    ),
                                    Text(
                                      " : ",
                                      style: TextStyle(color: Colors.black,fontSize: 20),
                                    ),
                                    Directionality(
                                      textDirection: TextDirection.ltr,
                                      child: AnimatedFlipCounter(
                                        textStyle: TextStyle(color: Colors.black,fontSize: 20),
                                        duration: const Duration(seconds: 1),
                                        value: time.hours!.toInt(),
                                        prefix: "ساعة ",
                                        //   suffix: ساعة":"",
                                      ),
                                    ),
                                  ],
                                );
                                //return Text('${time.hours} ساعة : ${time.min} '+context.read<LocaleBloc>().minutes,style: TextStyle(color: Colors.black,fontSize: 20),);
                              }
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: AnimatedFlipCounter(
                                      textStyle: TextStyle(color: Colors.black,fontSize: 20),
                                      duration: const Duration(seconds: 1),
                                      value: time.hours!.toInt(),
                                      prefix: "ساعة ",
                                      //    suffix: ساعة":"",
                                    ),
                                  ),
                                  Text(
                                    " : ",
                                    style: TextStyle(color: Colors.black,fontSize: 20),
                                  ),
                                  Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: AnimatedFlipCounter(
                                      textStyle: TextStyle(color: Colors.black,fontSize: 20),
                                      duration: const Duration(seconds: 1),
                                      value: time.days!.toInt(),
                                      prefix: "يوم ",
                                      //  suffix: ${context.read<LocaleBloc>().day}":"",
                                    ),
                                  ),
                                ],
                              );
                              //return Text('${time.days} ${context.read<LocaleBloc>().day} : ${time.hours} '+context.read<LocaleBloc>().hour,style: TextStyle(color: Colors.black),);
                            },
                          ),
                          Container(
                            color: white,
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: context.read<ExamBloc>().all_q.length,
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
                                                if (context.read<ExamBloc>().wrong_answer[index] != null)
                                                  Icon(
                                                    Icons.close,
                                                    color: Colors.red,
                                                    size: 50,
                                                  )
                                                else if (context.read<ExamBloc>().correct_answer[index] != null)
                                                  Icon(Icons.check, color: Colors.green, size: 50),
                                                Spacer(),
                                                Text(
                                                  "السؤال " + (index + 1).toString() + " : ",
                                                  textDirection: TextDirection.rtl,
                                                  style: TextStyle(fontSize: 18),
                                                ),
                                              ],
                                            ),
                                            if(context.read<ExamBloc>().all_q[index].photo!=null&& context.read<ExamBloc>().all_q[index].photo!= "null")
                                              Image.network(context.read<ExamBloc>().all_q[index].photo!),
                                            Text(
                                              context.read<ExamBloc>().all_q[index].question!,
                                              textDirection: TextDirection.rtl,
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Spacer(),
                                                Text(context.read<ExamBloc>().all_q[index].Answer1!),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                CircleAvatar(
                                                  radius: 5,
                                                  backgroundColor: Colors.black,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Spacer(),
                                                Text(context.read<ExamBloc>().all_q[index].Answer2!),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                CircleAvatar(
                                                  radius: 5,
                                                  backgroundColor: Colors.black,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Spacer(),
                                                Text(context.read<ExamBloc>().all_q[index].Answer3!),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                CircleAvatar(
                                                  radius: 5,
                                                  backgroundColor: Colors.black,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Spacer(),
                                                Text(context.read<ExamBloc>().all_q[index].Answer4!),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                CircleAvatar(
                                                  radius: 5,
                                                  backgroundColor: Colors.black,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              children: [
                                                Spacer(),
                                                answer_item(4, context, index),
                                                Spacer(),
                                                Container(
                                                  width: 2,
                                                  height: 25,
                                                  color: Colors.grey.shade300,
                                                ),
                                                Spacer(),
                                                answer_item(3, context, index),
                                                Spacer(),
                                                Container(
                                                  width: 2,
                                                  height: 25,
                                                  color: Colors.grey.shade300,
                                                ),
                                                Spacer(),
                                                answer_item(2, context, index),
                                                Spacer(),
                                                Container(
                                                  width: 2,
                                                  height: 25,
                                                  color: Colors.grey.shade300,
                                                ),
                                                Spacer(),
                                                answer_item(1, context, index),
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
                            onTap: () {
                              // timer_con?.disposeTimer();
                              // timer_con?.removeListener(() { });

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
                ));
          },
        ),
      ),
    );
  }

  Widget answer_item(int i, BuildContext context, index) {
    return TextButton(
        style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.transparent)),
        onPressed: () => context.read<ExamBloc>().add(shoose_event(index, i)),
        child: Text(
          "الاختيار " + (i).toString(),
          style: TextStyle(
              color: context.read<ExamBloc>().correct_answer[index] == i
                  ? Colors.green
                  : context.read<ExamBloc>().wrong_answer[index] == i
                      ? Colors.red
                      : Colors.black,
              fontWeight: context.read<ExamBloc>().all_answer[index] == i ? FontWeight.bold : FontWeight.normal),
        ));
  }
}
