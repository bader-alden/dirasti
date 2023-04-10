import 'package:dirasti/Layout/pdf.dart';
import 'package:dirasti/module/subject_module.dart';
import 'package:dirasti/module/teacher_module.dart';
import 'package:dirasti/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

import '../Bloc/main/main_bloc.dart';
import '../main.dart';
var v = 75;
class AllFile extends StatelessWidget {
  const AllFile({Key? key, required this.subject, required this.teacher}) : super(key: key);
  final subject_module subject;
  final teacher_module teacher;
  @override
  Widget build(BuildContext context) {
    FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    return BlocProvider(
      create: (context) => MainBloc()..add(get_file_event(subject.grade, subject.id,teacher.id)),
      child: BlocConsumer<MainBloc, MainState>(
        listener: (context, state) {
          // if(state is not_sub_file_state){
          //   v=250;
          //   print("okkkkkkkkk");
          // }
        },
        builder: (context, state) {
          var bloc_provider = context.read<MainBloc>();
          return Scaffold(
            appBar: appbar_back(subject.subject),
            body: Column(
              children: [
                SizedBox(height: 30,),
                banner_widget(subject.file_banner!),
                SizedBox(height: 20),
                // if(context.read<MainBloc>().all_exam_list.isEmpty)
                //   Expanded(child: Center(child: CircularProgressIndicator(),))
                // else
                  Expanded(child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                     itemCount: context.read<MainBloc>().all_file_list.length,
                      itemBuilder: (context, index) {
                        return _file_item(context ,index , bloc_provider , context.read<MainBloc>().all_file_list[index]);
                      }))
              ],
            ),
          );
        },
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
          context.read<MainBloc>().add(get_file_details_event(subject.grade, subject.id, teacher.id, model['id'].toString()));
        },
        child: Card(child: SizedBox(
          height: 100,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(model["price"].toString() == "0" ?"مجاني" : (model["price"]+" ل.س "),style: TextStyle(color: orange,fontSize:18,fontWeight: FontWeight.bold),textDirection: TextDirection.rtl,),
              ),
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
