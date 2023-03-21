import 'package:container_tab_indicator/container_tab_indicator.dart';
import 'package:dirasti/utils/cache.dart';
import 'package:dirasti/utils/dio.dart';
import 'package:flutter/material.dart';

import '../module/noti_module.dart';
import '../utils/const.dart';
TabController? _tab_con ;
List<noti_module> _noti_list = [];
class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tab_con = TabController(length: 2, vsync: this);
    dio.get_data(url: "/notices",quary: {"user_id":cache.get_data("id")}).then((value) {
    value?.data.forEach((e){
      _noti_list.add(noti_module.fromjson(e));
      if( _noti_list.length-1==value?.data.indexOf(e)){
        setState(() {});
      }
    });
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _noti_list.clear();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: white,
        actions: [
          Row(
            children: [
              Text("الإشعارات",style: TextStyle(color: blue,fontSize: 27),),
              SizedBox(width: 5,),
            ],
          )
        ],
      ),
      body: Column(
        children: [
          // SizedBox(height: 10,),
          // Padding(
          //   padding: const EdgeInsets.all(15.0),
          //   child: Container(
          //     decoration: BoxDecoration(color: Colors.grey.shade300,borderRadius: BorderRadius.circular(15)),
          //     height: 50,
          //     child: TabBar(
          //       controller: _tab_con,
          //       tabs: [
          //         Text('كل الإشعارات', style: TextStyle(color: _tab_con?.index == 0 ?Colors.white:Colors.black,fontSize: 22)),
          //         Text('الأحدث', style: TextStyle(color: _tab_con?.index == 1 ?Colors.white:Colors.black,fontSize: 22)),
          //       ],
          //       indicator: ContainerTabIndicator(
          //         color: blue,
          //         radius: BorderRadius.circular(10.0),
          //         //  padding: const EdgeInsets.symmetric(horizontal: 20),
          //       ),
          //       onTap: (index){
          //         setState((){});
          //        // page_con?.animateToPage(index,duration: Duration(milliseconds: 300), curve: Curves.linear);
          //       },
          //     ),
          //   ),
          // ),
          SizedBox(height: 15,),
          Expanded(
            child: ListView.separated(
                physics: BouncingScrollPhysics(),
                itemBuilder: (context,index){
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                  //  Icon(Icons.more_vert),
                    Spacer(),
                    Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(_noti_list[index].title??"",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold)),
                            SizedBox(width: MediaQuery.of(context).size.width/2,child: Text(_noti_list[index].body??"",textDirection: TextDirection.rtl,)),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(width: 20,),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(height: 100,width: 100,decoration: BoxDecoration(color: blue,borderRadius: BorderRadius.circular(15))),
                        SizedBox(height: 65,child: Image.asset("assets/clogo.png",color: Colors.white,)),
                      ],
                    )
                  ],
                ),
              );
            }, separatorBuilder: (context,index){
              return Container(color: Colors.grey.shade300,height: 1,);
            }, itemCount: _noti_list.length),
          )
        ],
      ),
    );
  }
}
