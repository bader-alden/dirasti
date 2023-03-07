import 'package:chips_choice_null_safety/chips_choice_null_safety.dart';
import 'package:dirasti/Layout/calendar.dart';
import 'package:dirasti/Layout/calendar.dart';
import 'package:dirasti/utils/const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';

import '../Bloc/calendar/calendar_bloc.dart';
var _time_con = TimePickerSpinnerController();
var _date_con = TimePickerSpinnerController();
var _body_con = TextEditingController();
int tag = 1;
var date;
var time;
List<String> options = ['العلوم', 'الرياضيات', 'الفيزياء', 'الكيمياء', 'الانكليزي', 'الفرنسي', 'العربي', 'الوطنية'];
class NewCalendar extends StatefulWidget {
  const NewCalendar({Key? key}) : super(key: key);

  @override
  State<NewCalendar> createState() => _NewCalendarState();
}

class _NewCalendarState extends State<NewCalendar> {
  @override
  void initState() {
    date = (DateTime.now().month-1).toString()+"/"+(DateTime.now().day-1).toString();
    time = (DateTime.now().hour).toString()+":"+(DateTime.now().minute).toString();
        super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) => CalendarBloc()..add(init_event("1/1")),
  child: BlocConsumer<CalendarBloc, CalendarState>(
  listener: (context, state) {
    // TODO: implement listener
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
                  source: options,
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
                          print(dateTime);
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
                          print(dateTime);
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
                        maxLength: null,
                        decoration: InputDecoration(border: InputBorder.none),
                      ))),
              SizedBox(
                height: 40,
              ),
              InkWell(
                onTap: (){
                  context.read<CalendarBloc>().add(insert_event(date, time, options[tag], _body_con.text));
                  print(date);
                  _body_con.clear();
                 Tost("تم الإضافة بنجاح", Colors.green);
                 Navigator.pop(context);
                },
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(color: blue,borderRadius: BorderRadius.circular(10)),
                    height: 50,
                    width: MediaQuery.of(context).size.width/1.5,
                    child: Center(child: Text("إضافة المهمة", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18)))),
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
