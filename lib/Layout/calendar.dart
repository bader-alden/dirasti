import 'package:container_tab_indicator/container_tab_indicator.dart';
import 'package:dirasti/Layout/new_calendar.dart';
import 'package:dirasti/module/calendar_module.dart';
import 'package:dirasti/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:intl/date_symbol_data_local.dart';

import '../Bloc/calendar/calendar_bloc.dart';
TabController? _month_con ;
TabController? _day_con ;
List<String> month_list = ['يناير' , 'فبراير' , 'مارس' , 'أبريل' , 'مايو' , 'يونيو' , 'يوليو' , 'أغسطس' , 'سبتمبر'  ,'أكتوبر'  , 'نوفمبر'  , 'ديسمبر'];
var number_of_day=30 ;
class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> with TickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    _month_con=TabController(length:12,vsync: this,initialIndex: DateTime.now().month-1);
    number_of_day =  check_number_day(DateTime.now().month);
    _day_con=TabController(length:number_of_day,vsync: this, initialIndex: DateTime.now().day-1);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return BlocProvider(
  create: (context) => CalendarBloc()..add(init_event((DateTime.now().month-1).toString()+"/"+(DateTime.now().day-1).toString())),
  child: BlocConsumer<CalendarBloc, CalendarState>(
  listener: (context, state) {
    // TODO: implement listener
  },
  builder: (context, state) {
    return Scaffold(
      floatingActionButton: InkWell(
        onTap: () async {
         // context.read<CalendarBloc>().add(insert_event("7/3", "12:20", "bbbba", "bbbbbb"));
        await  Navigator.push(context, MaterialPageRoute(builder: (context)=>NewCalendar()));
        context.read<CalendarBloc>().add(get_event(_month_con!.index.toString()+"/"+_day_con!.index.toString()));
        },
        child: CircleAvatar(radius: 35,
        backgroundColor: blue,
        child: Icon(Icons.add,size: 40,color: Colors.white,)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        actions: [
          Text("التقويم",style: TextStyle(color: blue,fontSize: 27),),
          SizedBox(width: 10,),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 40,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: TabBar(
                  physics: BouncingScrollPhysics(),
                  isScrollable: true,
                  controller: _month_con,
                  tabs: month_list.map((e) => Text(e, style: TextStyle(color: _month_con?.index == month_list.indexOf(e) ?Colors.white :Colors.black))).toList(),
                  indicator: ContainerTabIndicator(
                    color: blue,
                    width: 100,
                    height: 16,
                    radius: BorderRadius.circular(8.0),
                    padding: const EdgeInsets.all(20),
                  ),
                  onTap: (value){
                     setState(() {  });
                      number_of_day =  check_number_day(value+1);
                      _day_con=TabController(length:number_of_day,vsync: this,initialIndex: DateTime.now().day-1);

                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SizedBox(
              height: 95,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: TabBar(
                  physics: BouncingScrollPhysics(),
                  unselectedLabelColor: Colors.red,
                  isScrollable: true,
                  padding: EdgeInsets.zero,
                  indicatorPadding: EdgeInsets.zero,
                  labelPadding: EdgeInsets.all(5),
                  controller: _day_con,
                  tabs: List.generate(number_of_day, (index) => (index+1).toString()).map((e) => Container(
                    decoration: BoxDecoration(
                        color: _day_con!.index == int.parse(e)-1 ?Colors.transparent :Colors.grey[300]!,
                        borderRadius: BorderRadius.circular(8.0),),
                    width: 55,
                    height: 85,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(e, style: TextStyle(color: _day_con?.index == int.parse(e)-1 ?Colors.white :Colors.black)),
                        Text(get_day_name((int.parse(e))), style: TextStyle(color: _day_con?.index == int.parse(e)-1 ?Colors.white :Colors.black)),
                      ],
                    ),
                  )).toList(),
                  indicator: ContainerTabIndicator(
                    color: blue,
                    width: 60,
                    height: 85,
                    radius: BorderRadius.circular(8.0),
                    padding: const EdgeInsets.all(0),
                  ),
                  onTap: (value) async {
                   // setState(()  {});
                    context.read<CalendarBloc>().add(get_event(_month_con!.index.toString()+"/"+value.toString()));
                    print(value);
                    print(_month_con!.index);
                    print("----------------------");
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 20,),
          Expanded(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemBuilder: (context,index){
              return _calendar_item(index,context,context.read<CalendarBloc>().all_data[index]);
            },itemCount: context.read<CalendarBloc>().all_data.length,),
          )
        ],
      ),
    );
  },
),
);
  }

  int check_number_day(month) {
    if(month == 1 ||month ==3 ||month ==5 ||month == 7 ||month ==8||month ==10||month ==12) {
      return 31;
    } else {
      return 30;
    }
  }

  String get_day_name(int e)  {
    var num_day = e>=10 ?(e).toString() : "0"+(e).toString();
    var num_month = _month_con!.index+1>=10 ?(_month_con!.index+1).toString() : "0"+(_month_con!.index+1).toString();
  //  print(num_day);
     initializeDateFormatting("ar_SA", null);
    var now = DateTime.parse("2023-$num_month-$num_day");
    var formatter = DateFormat.E('ar_SA');
   // print(formatter.locale);
    String formatted = formatter.format(now);
    return formatted ;
  }

  Widget _calendar_item(int index, BuildContext context,calendar_module model) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(model.subject ?? "مادة العلوم", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                  Text(model.body??"المهمة"),
                  Text(model.time??"الوقت")
                ],
              ),
              SizedBox(width: 20,),
              Image.asset("assets/عربي.png", width: 50,),
              SizedBox(width: 10,),
            ],
          ),
        ),
      ),
    );
  }
}
