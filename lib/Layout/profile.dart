import 'package:container_tab_indicator/container_tab_indicator.dart';
import 'package:dirasti/Layout/signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../Bloc/main/main_bloc.dart';
import '../module/course_module.dart';
import '../utils/const.dart';
import 'courses_details.dart';

class Profile extends HookWidget {
  const Profile(this.user_name, {Key? key}) : super(key: key);
  final user_name;

  @override
  Widget build(BuildContext context) {
    var _tab_con = useTabController(initialLength: 2, initialIndex: 1);
    return BlocProvider(
      create: (context) => MainBloc()..add(init_porfile1())..add(init_porfile2(_tab_con.index)),
      child: BlocConsumer<MainBloc, MainState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: appbar_back("الملف الشخصي"),
            body: Column(
              children: [
                SizedBox(height: 40,),
                Center(child: Hero(tag: "porfile", child: Material(color: Colors.transparent, child: Image.asset("assets/avatar.png", height: 120)))),
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
                SizedBox(height: 30,),
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
                Expanded(child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context,index){
                  return course_item(context,index,context.read<MainBloc>().course_list[index]);
                }, itemCount: context.read<MainBloc>().course_list.length))
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
                  Text("السعر "+model.price!,style: TextStyle(color: orange,fontSize: 18)),
                  SizedBox(height: 5,),
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
                  SizedBox(width: MediaQuery.of(context).size.width-200,child: Text("نفاصيلx "*10,textDirection: TextDirection.rtl,overflow: TextOverflow.ellipsis,maxLines: 3,)),
                  Spacer(),
                  SizedBox(
                    height: 40,
                    width: MediaQuery.of(context).size.width-200,
                    child: Row(
                      children: [
                        Container(child: FilledButton(onPressed: (){
                      //    Navigator.push(context, MaterialPageRoute(builder: (context)=>CoursesDetails(subject: model.,teacher: teacher,course: model,)));
                        }, child: Text("عرض نفاصيل"),style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(blue)),)),
                        Spacer(),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                ],
              ),
            ),
            SizedBox(width: 20,),
            SizedBox(height:280,width:150,child:Image.asset("assets/img_1.png",height: 280,fit: BoxFit.fitHeight,)),

          ],
        ),
      ),
    );
  }
}
