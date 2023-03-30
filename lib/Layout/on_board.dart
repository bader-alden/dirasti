import 'package:dirasti/Layout/Login.dart';
import 'package:dirasti/Layout/signin.dart';
import 'package:dirasti/Layout/version.dart';
import 'package:dirasti/utils/const.dart';
import 'package:dirasti/utils/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hms_gms_availability/flutter_hms_gms_availability.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../Bloc/user/user_bloc.dart';

class OnBoard extends StatelessWidget {
  const OnBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: FutureBuilder(
            future:  dio.get_data(url: "/index/version"),
            builder: (context,snapshot) {
              if(snapshot.data!=null){
                PackageInfo.fromPlatform().then((valuee) {
                  if(snapshot.data?.data[0]['version']==valuee.version){
                    FlutterHmsGmsAvailability.isGmsAvailable.then((t) {
                     print(t?"gms":"hms");
                    });
                    FlutterHmsGmsAvailability.isHmsAvailable.then((t) {
                      print(t?"hms":"gms");
                    });
                  }else{
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Version(link:snapshot.data?.data[0]['link'])), (route) => false);
                  }
                });
              }
              return Center(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 15,),
                  Expanded(flex: 1,child: Image.asset("assets/onboard_logo.jpg")),
                      SizedBox(height: 15,),
                  Expanded(flex: 3,child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          Image.asset("assets/a1.png",width: 250,height: 250,fit: BoxFit.fitHeight,),
                          CircleAvatar(radius: 75,backgroundColor: blue),

                        ],
                      ),
                      Image.asset("assets/img_3.png"),
                    ],
                  )),
                  Expanded(flex: 4,child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("طريقك نحو النجاح ",style: TextStyle(color: blue,fontSize: 35,fontWeight: FontWeight.bold)),
                      SizedBox(height: 15,),
                  //    Text("طريقك نحو النجاح "*3,style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),textDirection: TextDirection.rtl),
                      SizedBox(height: 10,),
                      TextButton(onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => Signin(),)), child: Container(width: MediaQuery.of(context).size.width/1.2,height: 60,decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: blue),child: Center(child: Text("إنشاء حساب",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18)),),),),
                      SizedBox(height: 20,),
                      TextButton(onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => Login(),)), child: Container(width: MediaQuery.of(context).size.width/1.2,height: 60,decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: orange),child: Center(child: Text("تسجيل دخول",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18)))),),
                      SizedBox(height: 20,),
                    ],
                  ),)
                ]),
              );
            }
          ),
        ),
      );
  }
}
