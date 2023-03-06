import 'package:container_tab_indicator/container_tab_indicator.dart';
import 'package:dirasti/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:intl/date_symbol_data_local.dart';
TabController? _month_con ;
TabController? _day_con ;
List<String> month_list = ['يناير' , 'فبراير' , 'مارس' , 'أبريل' , 'مايو' , 'يونيو' , 'يوليو' , 'أغسطس' , 'سبتمبر'  ,'أكتوبر'  , 'نوفمبر'  , 'ديسمبر'];
var number_of_day=30 ;
class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> with TickerProviderStateMixin{
  @override
  void initState() {
    _month_con=TabController(length:12, vsync: this,initialIndex: DateTime.now().month-1);
    number_of_day =  check_number_day(DateTime.now().month);
    _day_con=TabController(length:number_of_day, vsync: this,initialIndex: DateTime.now().day-1);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CircleAvatar(radius: 35,
      child: Icon(Icons.add,size: 40,)),
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
                    setState(() {
                      number_of_day =  check_number_day(value+1);
                      _day_con=TabController(length:number_of_day, vsync: this,initialIndex: DateTime.now().day-1);
                    });
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
                    setState(()  {});
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
              return _calendar_item(index,context);
            },itemCount: 3,),
          )
        ],
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

  Widget _calendar_item(int index, BuildContext context) {
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
                  Text("مادة العلوم",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                  Text("aaaaaaaaaa"),
                  Text("aaaaaaaaaaa")
                ],
              ),
              SizedBox(width: 20,),
              Image.asset("assets/عربي.png",width: 50,),
              SizedBox(width: 10,),
            ],
          ),
        ),
      ),
    );
  }
}
