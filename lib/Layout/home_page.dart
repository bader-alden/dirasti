import 'package:dirasti/Bloc/bottom_nav/bottom_nav_bloc.dart';
import 'package:dirasti/module/subject_module.dart';
import 'package:dirasti/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Bloc/main/main_bloc.dart';
import '../Bloc/user/user_bloc.dart';
import 'Subject_type.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) => MainBloc()..add(init()),
  child: BlocConsumer<MainBloc, MainState>(
  listener: (context, state) {
    // TODO: implement listener
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
              InkWell(onTap:  (){},child: Image.asset("assets/avatar.png",height: 60)),
              Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("مرحبا بك",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25)),
                  SizedBox(height: 7,),
                  Text((context.read<MainBloc>().user_model?.name??"aaaaaaa")),
                ],
              ),
              SizedBox(width: 20,),
            ],
            ),
            SizedBox(height: 30,),
            banner_widget(),
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
              child: GridView.builder(
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
        Navigator.push(context, PageRouteBuilder(transitionDuration: Duration(milliseconds: 700),pageBuilder: (_,__,___)=>Subject_type(hero: index.toString(),subject:model)));
      },
      child: Hero(
        tag: index.toString(),
        child: Material(
          borderRadius:  BorderRadius.circular(10),
          color:  Color.fromRGBO(250, 250, 250, 1.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.bolt_outlined,size: 50,),
              SizedBox(height: 20,),
              Text(model!.subject!)
            ],
          ),
        ),
      ),
    ),
  );
}




