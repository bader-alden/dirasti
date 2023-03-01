import 'package:dirasti/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Bloc/user/user_bloc.dart';
import '../main.dart';
var _number_con=TextEditingController();

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    bool _is_loading = false;
    return Scaffold(
      body: BlocProvider(
  create: (context) => UserBloc(),
  child: BlocConsumer<UserBloc, UserState>(
  listener: (context, state) {
    if (state is scss_login) {
      // cache.save_data("id", "3");
      Tost("أهلا بك "+state.name, Colors.green);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => App(),
          ),
              (route) => false);
    }
    if (state is error_login) {
      print(state.error);
      _is_loading = false;
      Tost(state.error, Colors.red);
    }
  },
  builder: (context, state) {
    return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(height: 5,),
              Row(
                children: [
                  Card(child: BackButton(color: blue),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),elevation: 1),
                  Spacer(),
                  Image.asset( "assets/onboard_logo.jpg",width: 100),
                ],
              ),
              SizedBox(height: 30,),
              Text("تسجيل الدخول",style: TextStyle(color:blue,fontSize: 22,fontWeight: FontWeight.bold),),
              Spacer(),
              SizedBox(height: 20,),
              Text("رقم الهاتف",style: TextStyle(color:Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              Container(
                decoration: BoxDecoration(border: Border.all(color: Colors.grey),borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    SizedBox(width: 10,),
                    Center(child: Text("09",style: TextStyle(fontSize: 20),)),
                    Expanded(child: TextFormField(controller: _number_con,decoration: InputDecoration(border: InputBorder.none),keyboardType: TextInputType.number,style: TextStyle(fontSize: 20),)),
                  ],
                ),
              ),
              // SizedBox(height: 20,),
              // Text("الجنس",style: TextStyle(color:Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
              // SizedBox(height: 10,),
              // Container(
              //   decoration: BoxDecoration(border: Border.all(color: Colors.grey),borderRadius: BorderRadius.circular(10)),
              //   child: Padding(
              //     padding: const EdgeInsets.all(4.0),
              //     child: Directionality(
              //       textDirection: TextDirection.rtl,
              //       child: DropdownButton(items: ["ذكر","b"].map(drop_item).toList(), onChanged: (value){},value: "ذكر",isExpanded: true,alignment: Alignment.centerRight,
              //       underline: Text(""),
              //       ),
              //     ),
              //   ),
              // ),
              // SizedBox(height: 20,),
              // Text("الصف الدراسي",style: TextStyle(color:Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
              // SizedBox(height: 10,),
              // Container(
              //   decoration: BoxDecoration(border: Border.all(color: Colors.grey),borderRadius: BorderRadius.circular(10)),
              //   child: Padding(
              //     padding: const EdgeInsets.all(4.0),
              //     child: Directionality(
              //       textDirection: TextDirection.rtl,
              //       child: DropdownButton(items: ["ذكر","b"].map(drop_item).toList(), onChanged: (value){},value: "ذكر",isExpanded: true,alignment: Alignment.centerRight,
              //         underline: Text(""),
              //       ),
              //     ),
              //   ),
              // ),
              SizedBox(height: 10,),
              StatefulBuilder(
                builder: (context,setstatea) {
                  return Row(
                    children: [
                      Spacer(),
                      TextButton(onPressed: (){}, child: Text("الدعم الفني",style: TextStyle(fontSize: 15))),
                      Text("التواصل مع ",style: TextStyle(fontSize: 15)),
                    ],
                  );
                }
              ),
              Spacer(),
              StatefulBuilder(
                builder: (context,states) {
                  return TextButton(onPressed: (){
                      if(_number_con.text.length==8&&!_is_loading){
                        states((){
                          _is_loading=true;
                        });
                          context.read<UserBloc>().add(user_login(_number_con.text));
                      }else{
                        Tost("يرجى إدخال رقم جوال صالح", Colors.red);
                      }
                  }, child: Container(width: MediaQuery.of(context).size.width/1.2,height: 60,decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: blue),child: Center(child: _is_loading?CircularProgressIndicator(color: Colors.white,):Text("تسجيل الدخول",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18)))),);
                }
              ),
              Spacer(),
            ],
          ),
        ),
      );
  },
),
),
    );
  }  DropdownMenuItem drop_item(item) => DropdownMenuItem(alignment: Alignment.centerRight,value: item, child: Text(item,maxLines: 1,textDirection: TextDirection.rtl,overflow: TextOverflow.ellipsis,));

}
