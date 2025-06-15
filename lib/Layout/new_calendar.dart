import 'package:chips_choice_null_safety/chips_choice_null_safety.dart';
import 'package:dirasti/Layout/calendar.dart';
import 'package:dirasti/Layout/calendar.dart';
import 'package:dirasti/module/calendar_module.dart';
import 'package:dirasti/utils/const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';

import '../Bloc/calendar/calendar_bloc.dart';
var _time_con = TimePickerSpinnerController();
var _date_con = TimePickerSpinnerController();
var _body_con = TextEditingController();
int tag = 1;
var date;
var time;
class NewCalendar extends StatefulWidget {
  const NewCalendar({Key? key, this.list_subject, this.cal}) : super(key: key);
  final list_subject ;
  final calendar_module? cal;
  @override
  State<NewCalendar> createState() => _NewCalendarState(list_subject,cal);
}

class _NewCalendarState extends State<NewCalendar> {
  final List list_subject;
  final calendar_module? cal;

  _NewCalendarState(this.list_subject, this.cal);
  @override
  void initState() {
    date = (DateTime.now().month-1).toString()+"/"+(DateTime.now().day-1).toString();
    time = (DateTime.now().hour).toString()+":"+(DateTime.now().minute).toString();
        super.initState();

        if(cal != null){
          date = cal?.date;
          time = cal?.time;
          _body_con.text = cal!.body!;
          tag = list_subject.indexWhere((element) => element['subject'] == cal?.subject);
        }
  }
  @override
  Widget build(BuildContext context) {
    // FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    bool _is_check = false;
    return BlocProvider(
  create: (context) => CalendarBloc()..add(init_event("1/1")),
  child: BlocConsumer<CalendarBloc, CalendarState>(
  listener: (context, state) {
  },
  builder: (context, state) {
    return Scaffold(
      appBar: appbar_back("إضافة مهمة"),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
           physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                height: 30,
              ), Text(
                "المادة",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                height: 5,
              ),

          Container(
            width: double.infinity,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: ChipsChoice<int>.single(
                choiceActiveStyle: C2ChoiceStyle(
                    color: Colors.white,borderRadius: BorderRadius.circular(10),borderColor: blue,backgroundColor: blue
                ),
                value: tag,
                onChanged: (val) => setState(() => tag = val),
                choiceItems: C2Choice.listFrom<int, String>(
                  source: list_subject.map((e) => e['subject'] as String).toList(),
                  value: (i, v) => i,
                  label: (i, v) => v,
                  style: (i, v) => C2ChoiceStyle(color: blue),
                  activeStyle: (i, v) => C2ChoiceStyle(color: blue),
                ), choiceStyle: C2ChoiceStyle(
                  color: Colors.black,borderRadius: BorderRadius.circular(10),borderColor: Colors.grey.shade300,backgroundColor: Colors.transparent
              ),wrapped: true,
              ),
            ),
          ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "التاريخ",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TimePickerSpinnerPopUp(
                        controller: _date_con,
                        mode: CupertinoDatePickerMode.date,
                        initTime: DateTime.now(),
                        // minTime: DateTime.now().subtract(const Duration(days: 10)),
                        // maxTime: DateTime.now().add(const Duration(days: 10)),
                        barrierColor: Colors.black12, //Barrier Color when pop up show
                        onChange: (dateTime) {
                          date = (dateTime.month-1).toString()+"/"+(dateTime.day-1).toString();
                        },
                        timeWidgetBuilder: (datetime){
                          return InkWell(
                            onTap: (){
                              _date_con.showMenu();
                            },
                            child: Container(
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.shade300, width: 2)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Icon(Icons.calendar_today),
                                      Spacer(),
                                      Text(datetime.year.toString()+" / "+datetime.month.toString()+" / "+datetime.day.toString(),style: TextStyle(fontSize: 16),),
                                    ],
                                  ),
                                )),
                          );
                        },
                      )
                    ],
                  )),
                  SizedBox(width: 10),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "الوقت",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TimePickerSpinnerPopUp(
                        controller: _time_con,
                        mode: CupertinoDatePickerMode.time,
                        initTime: DateTime.now(),
                        // minTime: DateTime.now().subtract(const Duration(days: 10)),
                        // maxTime: DateTime.now().add(const Duration(days: 10)),
                        barrierColor: Colors.black12, //Barrier Color when pop up show
                        onChange: (dateTime) {
                          time = dateTime.hour.toString()+":"+dateTime.minute.toString();
                        },
                        timeWidgetBuilder: (datetime) {
                          return InkWell(
                            onTap: (){
                              _time_con.showMenu();
                            },
                            child: Container(
                                decoration:
                                    BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.shade300, width: 2)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Icon(Icons.access_time),
                                      Spacer(),
                                      Text(datetime.hour.toString() +" : "+datetime.minute.toString(),style: TextStyle(fontSize: 16),),
                                    ],
                                  ),
                                )),
                          );
                        },
                        // Customize your time widget
                        // timeWidgetBuilder: (dateTime) {},

                        // Customize your time format
                        // timeFormat: 'dd/MM/yyyy',

                        // Customize your time format
                        // timeFormat: 'dd/MM/yyyy',
                      )
                    ],
                  )),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "وصف المهمة",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                  height: 200,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.shade300, width: 2)),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2),
                      child: TextFormField(
                        controller: _body_con,
                        textDirection: TextDirection.rtl,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        maxLength: null,
                        decoration: InputDecoration(border: InputBorder.none),
                      ))),
              SizedBox(height: 20,),
              StatefulBuilder(builder: (context, setstatea) {
                return Row(
                  children: [
                    Spacer(),
                    Text("إرسال إشعار عند موعد المهمة", style: TextStyle(fontSize: 18), textDirection: TextDirection.rtl),
                    Checkbox(
                        value: _is_check,
                        onChanged: (value) {
                          setstatea(() {
                            _is_check = !_is_check;
                          });
                        },
                        fillColor: MaterialStatePropertyAll(blue)),
                  ],
                );
              }),
              SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: (){
                  var a = _body_con.text;
                  if(list_subject[tag]['subject'] != null && _body_con.text !=""){
                    if(cal == null){
                      context.read<CalendarBloc>().add(insert_event(date, time, list_subject[tag]['subject'], _body_con.text));
                      Navigator.pop(context);
                    }

                    // val text = call.argument<String>("text")
                    // val hour = call.argument<String>("hour")
                    // val min = call.argument<String>("min")
                    // val year = call.argument<String>("year")
                    // val month = call.argument<String>("month")
                    // val day = call.argument<String>("day")
                   // Tost("تم الإضافة بنجاح", Colors.green);
                  else{
                    context.read<CalendarBloc>().add(updeate_event(cal?.id,date, time, list_subject[tag]['subject'], _body_con.text));
                    _body_con.clear();
                    Tost("تم التعديل بنجاح", Colors.green);
                    Navigator.pop(context);
                  }
                  if(_is_check){
                    const platform = MethodChannel('samples.flutter.dev/battery');
                    platform.invokeMethod('add',{
                      "text":"تذكير : " + "\n" +a,
                      "hour":time.toString().split(":")[0],
                      "min":time.toString().split(":")[1],
                      "year":"2023",
                      "month":date.toString().split("/")[0],
                      "day":date.toString().split("/")[1],
                    });
                  }else{
                    Tost("تم الاضافة بنجاح", Colors.green);
                  }
                    _body_con.clear();
                  }else{
                  Tost("يرجى تعبئة جميع الحقول", Colors.red);
                  }


                },
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(color: blue,borderRadius: BorderRadius.circular(10)),
                    height: 50,
                    width: MediaQuery.of(context).size.width/1.5,
                    child: Center(child: Text(cal == null ? "إضافة المهمة":"تعديل المهمة", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18)))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  },
),
);
  }
}
