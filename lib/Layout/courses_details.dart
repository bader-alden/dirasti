import 'package:container_tab_indicator/container_tab_indicator.dart';
import 'package:dirasti/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
TabController? tab_con ;
TabController? video_tab_con ;
PageController? page_con;
List test_list_video = ["الاولى","الثاتية","الثالثة","الرابعة","الاولaى","الثaاتية","الثالaثة","الaرابعة"];
class CoursesDetails extends StatefulWidget {
  const CoursesDetails({Key? key}) : super(key: key);

  @override
  State<CoursesDetails> createState() => _CoursesDetailsState();
}

class _CoursesDetailsState extends State<CoursesDetails>with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    tab_con= TabController(length: 2,vsync: this,initialIndex: 1);
    video_tab_con= TabController(length: test_list_video.length,vsync: this,initialIndex: test_list_video.length-1);
     page_con=PageController(initialPage: 1);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar_back("اسم الكورس"),
      body: Column(
        children: [
          SizedBox(height: 30,),
          banner_widget(),
          SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.grey.shade200,borderRadius: BorderRadius.circular(10)),
              child: TabBar(
                controller: tab_con,
                tabs: [
                  Text('الدروس', style: TextStyle(color: tab_con?.index == 0 ?Colors.white:Colors.black,fontSize: 22)),
                  Text('التفاصيل', style: TextStyle(color: tab_con?.index == 1 ?Colors.white:Colors.black,fontSize: 22)),
                ],
                indicator: ContainerTabIndicator(
                  color: blue,
                  radius: BorderRadius.circular(10.0),
                  //  padding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                onTap: (index){
                  setState((){});
                  page_con?.animateToPage(index,duration: Duration(milliseconds: 300), curve: Curves.linear);
                },
              ),
            ),
          ),
          SizedBox(height: 10,),
          Expanded(child: PageView(
             controller: page_con,
            onPageChanged: (index){setState((){});
              tab_con?.animateTo(index);
            },
            children: [
              course_details_page_2(context,setState),
              course_details_page_1(context),
            ],
          ))
        ],
      ),
    );
  }
}
Widget course_details_page_1(context){
  print(MediaQuery.of(context).size.height / 800);
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10),
    child: Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              Row(
                children: [
                  Text("السعر 6000 ل.س",style: TextStyle(fontSize: 22,color: orange,fontWeight: FontWeight.bold),),
                  Spacer(),
                  Text("اسم الكورس",style: TextStyle(fontSize: 22,color: Colors.black,fontWeight: FontWeight.bold),),
                ],
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  Spacer(),
                  Text(": التفاصيل",style: TextStyle(fontSize: 20,color: blue,fontWeight: FontWeight.bold),),
                ],
              ),
              Text("data"*200,textDirection: TextDirection.rtl),
            ],
          ),
        ),
        //Spacer(),
        InkWell(onTap: (){}, child: Container(width: double.infinity,height: 50,decoration:BoxDecoration(color: blue,borderRadius: BorderRadius.circular(10)),child: Center(child: Text("شراء الكورس",style: TextStyle(color: Colors.white,fontSize: 18),))))
      ],
    ),
  );
}
Widget course_details_page_2(context,setstate){
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(": الواحدات",style: TextStyle(color: orange,fontSize: 22,fontWeight: FontWeight.bold),),
        SizedBox(height: 10,),
        TabBar(
          isScrollable: true,
          padding: EdgeInsets.zero,
          indicatorPadding:const EdgeInsets.symmetric(horizontal: 4),
          labelPadding: EdgeInsets.zero,
          controller: video_tab_con,
          tabs: test_list_video.map((e) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Container(width: 80,decoration: BoxDecoration(border: Border.all(),borderRadius: BorderRadius.circular(10)),padding: EdgeInsets.all(4),child: Center(child: Text(e, style: TextStyle(color:video_tab_con?.index==test_list_video.reversed.toList().indexOf(e) ?Colors.white:Colors.black,fontSize: 15)))),
          ),).toList().reversed.toList(),
          indicator: ContainerTabIndicator(
            color: blue,
            padding: EdgeInsets.zero,
            radius: BorderRadius.circular(12.0),
            //  padding: const EdgeInsets.symmetric(horizontal: 20),
          ),
          onTap: (index){
            setstate((){});
          },
        ),
        SizedBox(height: 20,),
        Expanded(child: ListView.builder(
          physics: BouncingScrollPhysics(),
            itemCount: 5,
            itemBuilder: (context,index){
          return InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: (){},
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(Icons.play_arrow_rounded,size: 50),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                      Text("اسم الدرس",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                      Text(25.toString()+" دقيقة ",style: TextStyle(color: Colors.grey),textDirection: TextDirection.rtl,)
                      ],
                    ),
                    SizedBox(width: 15,),
                   // SizedBox(height: 75,width: 75,child: Placeholder(),)
                   //  SizedBox(height: 75,width: 75,child: Center(child: Text((index+1).toString(),style: TextStyle(fontSize: 30),)),)
                    Container(decoration: BoxDecoration(color: index == 1 ? orange:blue,borderRadius: BorderRadius.circular(15)),height: 75,width: 75,child: Center(child: Text((index+1).toString(),style: TextStyle(fontSize: 30,color: Colors.white),)),)
                  ],
                ),
              ),
            ),
          );
        }))
      ],
    ),
  );
}
