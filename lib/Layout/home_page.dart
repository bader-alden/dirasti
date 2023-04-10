import 'package:dirasti/Bloc/bottom_nav/bottom_nav_bloc.dart';
import 'package:dirasti/Layout/profile.dart';
import 'package:dirasti/Layout/version.dart';
import 'package:dirasti/module/subject_module.dart';
import 'package:dirasti/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

import '../Bloc/main/main_bloc.dart';
import '../Bloc/user/user_bloc.dart';
import 'Subject_type.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    return BlocProvider(
  create: (context) => MainBloc()..check_version()..add(init()),
  child: BlocConsumer<MainBloc, MainState>(
  listener: (context, state) {
    if(state is not_match_version){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Version(link:state.link)), (route) => false);
    }
  },
  builder: (context, state) {
    return Container(
      color:  Color.fromRGBO(250, 250, 250, 1.0),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(height: 0,),
            Row(children: [
              SizedBox(width: 15,),
              if(context.read<MainBloc>().user_model?.is_male!=null)
              InkWell(onTap:  ()
                  async {
                   await Navigator.push(context, MaterialPageRoute(builder: (contexta)=>Profile(context.read<MainBloc>().user_model?.name??"",context.read<MainBloc>().user_model?.is_male??"")));
                  context.read<MainBloc>().add(init());
                  },child: Hero(tag: "porfile",child: Material(color: Colors.transparent,child: Image.asset(context.read<MainBloc>().user_model!.is_male! ?"assets/avatar1.png" : "assets/avatar.png",height: 60)))),

              Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("مرحبا بك",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25)),
                  SizedBox(height: 7,),
                  Hero(tag:"user name",child: Material(color: Colors.transparent,child: Text((context.read<MainBloc>().user_model?.name??"....."),style: TextStyle(backgroundColor: Colors.transparent),))),
                ],
              ),
              SizedBox(width: 20,),
            ],
            ),
            SizedBox(height: 30,),
            if(context.read<MainBloc>().main_banner_image !="")
            banner_widget(context.read<MainBloc>().main_banner_image)
            else
              Container(height: 200,child:  Center(child: Image.asset("assets/loading.gif",width: 75,))),
            SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("تريدها",textDirection: TextDirection.rtl,style: TextStyle(color: orange,fontSize: 25,fontWeight: FontWeight.bold)),
              SizedBox(width: 5,),
                Text("اختر المادة التي",textDirection: TextDirection.rtl,style: TextStyle(color: blue,fontSize: 25,fontWeight: FontWeight.bold)),
                SizedBox(width: 35,),
              ],
            ),
            SizedBox(height: 30,),
            Expanded(child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: context.read<MainBloc>().subject_list.length == 0 ?
                  //Center(child: CircularProgressIndicator(color: blue,))
              Center(child: Image.asset("assets/loading.gif",width: 75,))
                  :GridView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: context.read<MainBloc>().subject_list.length,
                  // physics: BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 27,mainAxisSpacing: 27),
                  itemBuilder: (context,index){
             //   return Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),elevation: 5,child: home_page_grade_item(context,index),);}),
                 return  home_page_grade_item(context,index,context.read<MainBloc>().subject_list[index]);}),
            )),
          ],
        ),
      ),
    );
  },
),
);
  }
}
int a = 50;
home_page_grade_item(BuildContext context, int index,subject_module model) {
  return Container(
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white,boxShadow: [
      BoxShadow(color: Colors.black.withOpacity(0.04),offset: Offset(0, 5),),
      BoxShadow(color: Colors.black.withOpacity(0.04),offset: Offset(0, -5)),
      BoxShadow(color: Colors.black.withOpacity(0.04),offset: Offset(5,0),),
      BoxShadow(color: Colors.black.withOpacity(0.04),offset: Offset(-5,0))
    ]),
    child: InkWell(
      onTap: (){
       // context.read<BottomNavBloc>().emit(BottomNavState(1));
        Navigator.push(context, PageRouteBuilder(transitionDuration: Duration(milliseconds: 400),pageBuilder: (_,__,___)=>Subject_type(hero: index.toString(),subject:model)));
      },
      child: Hero(
        tag: index.toString(),
        child: Material(
          borderRadius:  BorderRadius.circular(10),
          color:  Color.fromRGBO(250, 250, 250, 1.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(model!.photo!,height: 65,),
              //Icon(Icons.bolt_outlined,size: 50,),
              SizedBox(height: 20,),
              Text(model!.subject!,style: TextStyle(fontWeight: FontWeight.bold),)
            ],
          ),
        ),
      ),
    ),
  );
}




