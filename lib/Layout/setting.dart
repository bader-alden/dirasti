import 'dart:io';

import 'package:dirasti/Layout/location.dart';
import 'package:dirasti/Layout/social.dart';
import 'package:dirasti/Layout/terms.dart';
import 'package:dirasti/utils/const.dart';
import 'package:dirasti/utils/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
class Setting extends StatelessWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    return Scaffold(
      resizeToAvoidBottomInset: false,

      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        actions: [
          Text("الإعدادات",style: TextStyle(color: blue,fontSize: 27),),
          SizedBox(width: 10,),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 10,),
          setting_item("أماكن بيع أكواد التفعيل",Icons.location_on_outlined,()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>Location()))),
          setting_item("سياسة الخصوصية و الاستخدام",Icons.my_library_books_outlined,()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>Terms()))),
          setting_item("شارك التطبيق",Icons.ios_share_outlined,() async {
            showCupertinoDialog(context: context, builder: (context)=>Center(child: Container(decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10)),width: 75,height: 75,child:  Center(child: Image.asset("assets/loading.gif",width: 75,)),),));
            dio.get_data(url: "/index/version").then((value) async {
              Navigator.pop(context);
             // launchUrl(Uri.parse(value?.data[0]["link"]),mode:LaunchMode.externalNonBrowserApplication );
              final bytes = await rootBundle.load('assets/share.jpg');
              final list = bytes.buffer.asUint8List();
              final tempDir = await getTemporaryDirectory();
              final file = await File('${tempDir.path}/share.jpg').create();
              file.writeAsBytesSync(list);
              await Share.shareXFiles([XFile(file.path)],text: " تطبيق دراستي دليلك الأول للنجاح "+"\n عبر الرابط:" +"\n"+ value?.data[0]["link"]);
            });

          }),
          setting_item("التواصل الاجتماعي",Icons.smartphone_outlined,()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>Social()))),
          setting_item("التواصل  مع الدعم الفني",Icons.support_agent,(){
            showCupertinoDialog(context: context, builder: (context)=>Center(child: Container(decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10)),width: 75,height: 75,child:  Center(child: Image.asset("assets/loading.gif",width: 75,))),));
            dio.get_data(url: "/data/the_support").then((value) {
              Navigator.pop(context);
              launchUrl(Uri.parse(value?.data[0]["link"]),mode:LaunchMode.externalNonBrowserApplication );
            });
          }),
        ],
      ),
    );
  }
}



Widget setting_item(String text,IconData icon,ontap){
  return  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
    child: InkWell(
      overlayColor: MaterialStatePropertyAll(Colors.transparent),
      onTap: ontap,
      child: Row(
        children: [
          SizedBox(width: 10,),
          Icon(Icons.arrow_back_ios_new),
          Spacer(),
          Text(text,style: TextStyle(fontSize: 19,fontWeight: FontWeight.bold)),
          SizedBox(width: 15,),
          Card(elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(icon,color: blue),
              )),
          SizedBox(width: 10,),
        ],
      ),
    ),
  );
}
