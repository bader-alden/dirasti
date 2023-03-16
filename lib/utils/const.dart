import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Color orange = Color(-954107);
Color blue = Color(-16037246);
Color black = Color(-14869219);
Color white = Color.fromRGBO(250, 250, 250, 1.0);

Widget banner_widget (String link) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30),
    child: Container(width: double.infinity,height: 200,decoration: BoxDecoration(color: Colors.transparent,borderRadius: BorderRadius.circular(20)),child: Image.network(link,fit: BoxFit.fill),),
  );
}
void Tost(String msg, Color color) => Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: color,
    textColor: Colors.white,
    fontSize: 16.0);

AppBar appbar_back(text){
  return AppBar(
    backgroundColor:white,
    elevation: 0,leading:  Row(
      children: [
        SizedBox(width: 5,),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: BackButton(color: blue),
          )),
      ],
    ),
    actions: [
      Center(child: Text(text,style: TextStyle(color: blue,fontSize: 23,fontWeight: FontWeight.bold),)),
      SizedBox(width: 20,),
    ],);
}