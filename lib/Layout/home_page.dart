import 'package:dirasti/Bloc/bottom_nav/bottom_nav_bloc.dart';
import 'package:dirasti/utills/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    //    appBar: AppBar(
    //   leading: IconButton(onPressed: (){},icon: Image.asset("assets/avatar.png")),
    //   actions: [
    //     Row(
    //       children: [
    //         Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             Text("مرحبا بك"),
    //          SizedBox(height: 5,),
    //             Text("اسم الطالب"),
    //           ],
    //         ),
    //         SizedBox(width: 20,),
    //       ],
    //     )
    //   ],
    // ),
    body: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(height: 10,),
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
                Text("اسم الطالب"),
              ],
            ),
            SizedBox(width: 20,),
          ],
          ),
          SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Container(width: double.infinity,height: 200,decoration: BoxDecoration(color: Colors.blue,borderRadius: BorderRadius.circular(20))),
          ),
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
                physics: BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 27,mainAxisSpacing: 27),
                itemBuilder: (context,index){
              return Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),child: home_page_grade_item(context,index),);}),
              //  return Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: Colors.white,boxShadow: [
              //    BoxShadow(color: Colors.grey.shade200,offset: Offset(0, 4),),
              //    BoxShadow(color: Colors.grey.shade200,offset: Offset(0, -4)),
              //  BoxShadow(color: Colors.grey.shade200,offset: Offset(4,0),),
              //    BoxShadow(color: Colors.grey.shade200,offset: Offset(-4,0))
              //     ]),child: home_page_grade_item(context,index),);}),
          )),
        ],
      ),
    ),
    );
  }
}
int a = 50;
home_page_grade_item(BuildContext context, int index) {
  return InkWell(
    onTap: (){
      print(index);
     // context.read<BottomNavBloc>().emit(BottomNavState(1));
      Navigator.push(context, PageRouteBuilder(transitionDuration: Duration(seconds: 1),pageBuilder: (_,__,___)=>new_page(hero: index.toString(),)));
    },
    child: Hero(
      tag: index.toString(),
      child: Material(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bolt_outlined,size: 50,),
            SizedBox(height: 20,),
            Text("aaaaaaaaa")
          ],
        ),
      ),
    ),
  );
}

class new_page extends StatelessWidget {
  const new_page({Key? key, this.hero}) : super(key: key);
final hero;
  @override
  Widget build(BuildContext context) {
    return
      Hero(
        tag: hero.toString(),
        child: Material(
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(backgroundColor: Colors.white,elevation: 0,leading:  BackButton(color: Colors.black),),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bolt_outlined,size: 50,),
                  SizedBox(height: 20,),
                  Text("aaaaaaaaa")
                ],
              ),
            ),
          ),
        ),
      );
  }
}

