import 'package:container_tab_indicator/container_tab_indicator.dart';
import 'package:dirasti/Layout/pdf.dart';
import 'package:dirasti/Layout/signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

import '../Bloc/main/main_bloc.dart';
import '../main.dart';
import '../module/course_module.dart';
import '../utils/const.dart';
import 'courses_details.dart';
int v =75;

class Profile extends HookWidget {
  const Profile(this.user_name, this.is_male, {Key? key}) : super(key: key);
  final user_name;
  final is_male;

  @override
  Widget build(BuildContext context) {
    FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    var _tab_con = useTabController(initialLength: 2, initialIndex: 1);
    return BlocProvider(
      create: (context) => MainBloc()..add(init_porfile1())..add(init_porfile2(_tab_con.index)),
      child: BlocConsumer<MainBloc, MainState>(
        listener: (context, state) {},
        builder: (context, state) {
          var bloc_providor = context.read<MainBloc>();
          return Scaffold(
            appBar: appbar_back("الملف الشخصي"),
            body: Column(
              children: [
                SizedBox(height: 40,),
                Center(child: Hero(tag: "porfile", child: Material(color: Colors.transparent, child: Image.asset((context
                    .read<MainBloc>()
                    .user_model
                    ?.is_male ?? is_male)?"assets/avatar1.png" : "assets/avatar.png", height: 120)))),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Spacer(),
                    if(context.read<MainBloc>().user_model!=null)
                    IconButton(onPressed: () async {
                    await  Navigator.push(context, MaterialPageRoute(builder: (contextb)=>Signin(type: "edit",data: context.read<MainBloc>().user_model,)));
                    context.read<MainBloc>().add(init_porfile1());
                    },icon: Icon(Icons.edit,size:40)),
                    SizedBox(width: 20,),
                    Hero(tag: "user name",
                        child: Material(color: Colors.transparent,
                            child: Text((context
                                .read<MainBloc>()
                                .user_model
                                ?.name ?? user_name), style: TextStyle(backgroundColor: Colors.transparent, fontSize: 22),))),

                    SizedBox(width: 60,),
                    Spacer(),
                  ],
                ),
                if(context.read<MainBloc>().user_model?.mobile_id!=null)
                Text("09"+(context
                    .read<MainBloc>()
                    .user_model
                    ?.mobile_id??""), style: TextStyle( fontSize: 20,color: Colors.grey),),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
                    child: TabBar(
                      controller: _tab_con,
                      tabs: [
                        Text('الورقيات', style: TextStyle(color: context.read<MainBloc>().porfile_tab_index == 0 ? Colors.white : Colors.black, fontSize: 22)),
                        Text('الكورسات', style: TextStyle(color: context.read<MainBloc>().porfile_tab_index == 1 ? Colors.white : Colors.black, fontSize: 22)),
                      ],
                      indicator: ContainerTabIndicator(
                        color: blue,
                        height: 50,
                        radius: BorderRadius.circular(10.0),
                        //  padding: const EdgeInsets.symmetric(horizontal: 20),
                      ),
                      onTap: (index) {
                        context.read<MainBloc>().update_profile_index(_tab_con.index);
                        context.read<MainBloc>().add(init_porfile2(_tab_con.index));
                        //  setState(() {});
                        // sets((){});
                        // if(!is_video_play){
                        //   context.read<MainBloc>().add(watch_event(0));
                        // }
                        //page_con?.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.linear);
                      },
                    ),
                  ),
                ),
                if(state is loading_porfile_state)
                  Expanded(
                    child: Column(
                      children: [
                        Spacer(),
                        Center(child: CircularProgressIndicator()),
                        Spacer()
                      ],
                    ),
                  )else
                if(state is empty_profile_state)
                  Expanded(
                    child: Column(
                      children: [
                        Spacer(),
                       Text("لم تشتري أي منتج بعد",style: TextStyle(fontSize: 22),),
                        Spacer()
                      ],
                    ),
                  )
                else
                  if(_tab_con.index==1)
                Expanded(child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context,index){
                  return course_item(context,index,context.read<MainBloc>().course_list[index]);
                }, itemCount: context.read<MainBloc>().course_list.length))
                else  Expanded(child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context,index){
                        return _file_item(context,index,bloc_providor,context.read<MainBloc>().my_file_list[index]);
                      }, itemCount: context.read<MainBloc>().my_file_list.length))
              ],
            ),
          );
        },
      ),
    );
  }


  Widget course_item(BuildContext context, int index, course_module model) {
    return Card(
      child: SizedBox(
        height: 270,
        //  width: MediaQuery.of(context).size.width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(height: 10,),
                  Text(model.name??"اسم الكورس",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22)),
                  SizedBox(height: 5),
                  // Text("السعر "+model.price!,style: TextStyle(color: orange,fontSize: 18)),
                  // SizedBox(height: 5,),
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
            SizedBox(width: 20,),
            SizedBox(height:280,width:150,child:Image.network(model.photo!,height: 280,fit: BoxFit.fitHeight,)),

          ],
        ),
      ),
    );
  }
  Widget _file_item(BuildContext context, int index, MainBloc bloc_provider, Map model) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () async {
          showDialog(
              useSafeArea: false,
              context: context, builder: (context)=>WillPopScope(
            onWillPop: () async {
              v = 75;
              bloc_provider.emit(get_exam_state());
              return await true;
            },
            child: BlocProvider.value(
              value: bloc_provider,
              child: BlocConsumer<MainBloc, MainState>(
                listener: (context, state) async {
                  if(state is not_sub_file_state){
                    v=250;
                    print("okkkkkkkkk");
                  }
                  if(state is get_file_link_state){
                    v=75;
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Pdf(title: model["name"],link: state.link,)));
                  }
                },
                builder: (context, state) {
                  return Center(
                    child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        height: v.toDouble(),
                        width: v.toDouble(),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(color:Colors.white,borderRadius: BorderRadius.circular(10)),
                        child: state is not_sub_file_state ?
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Spacer(),
                              Text("لم تقم بشراء الكورس ",style: TextStyle(color: Colors.black,fontSize: 22),),
                              Spacer(),
                              Expanded(
                                child: Material(
                                  child: InkWell(
                                    onTap: (){
                                      v = 75;
                                      bloc_provider.emit(get_exam_state());
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      home_page_con.jumpToPage(1);
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration( color: orange,borderRadius: BorderRadius.circular(10)),
                                      child: Center(child: Text("شراء",style: TextStyle(color: Colors.black,fontSize: 22),)),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                            :CircularProgressIndicator(color:blue,)),
                  );
                },
              ),
            ),
          ));
          context.read<MainBloc>().add(get_file_details_event(model['grade'], model['subject'],model['teacher_name'], 1));
        },
        child: Card(child: SizedBox(
          height: 100,
          child: Stack(
            children: [
              // Padding(
              //   padding: const EdgeInsets.all(20.0),
              //   child: Text("5000"+" ل.س ",style: TextStyle(color: orange,fontSize:18,fontWeight: FontWeight.bold),textDirection: TextDirection.rtl,),
              // ),

              Row(
                children: [

                  // Center(
                  //   child: Container(padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                  //       decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: blue),
                  //       child: Text("ابدأ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
                  // ),
                  Spacer(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(model["name"]??"اسم الاختبار", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                      Text(model["des"]??"30 دقيقة",style: TextStyle(fontSize: 12),)
                    ],
                  ),
                  SizedBox(width: 10,),
                  Image.asset("assets/file.png", height: 50,),
                  SizedBox(width: 20,),
                ],
              ),
            ],
          ),
        ),),
      ),
    );
  }

}
