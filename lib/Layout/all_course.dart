import 'package:dirasti/Layout/courses_details.dart';
import 'package:dirasti/utils/const.dart';
import 'package:flutter/material.dart';

class AllCourse extends StatelessWidget {
  const AllCourse({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: appbar_back("مادة العلوم"),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(height: 30,),
            Center(
              child: CircleAvatar(
                radius: 75,
              ),
            ),
            SizedBox(height: 15,),
            Center(child: Text("اسم الاستاذ",style: TextStyle(fontSize: 24),),),
            SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("جميع الكورسات",style: TextStyle(fontSize: 24,color: orange,fontWeight: FontWeight.bold),),
                SizedBox(width: 20,)
              ],
            ),
            SizedBox(height: 15,),
            Expanded(child: ListView.builder(
                shrinkWrap: true,
                itemCount: 5,
                itemBuilder: (context,index){
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
                          Text("اسم الكورس",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22)),
                          SizedBox(height: 5),
                          Text("السعر 5000",style: TextStyle(color: orange,fontSize: 18)),
                          SizedBox(height: 5,),
                          Row(
                            children: [
                              Text(" ساعة "),
                              Text("12 "),
                              Icon(Icons.timelapse),
                              SizedBox(width: 10,),
                              Text(" درس "),
                              Text("13"),
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
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>CoursesDetails()));
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
            }))
          ],
        ),
      );
  }
}
