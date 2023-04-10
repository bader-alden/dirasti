import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/const.dart';

class Version extends StatelessWidget {
  const Version({Key? key, this.link}) : super(key: key);
final link;
  @override
  Widget build(BuildContext context) {
    FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    return Scaffold(
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("يتوفر إصدار جديد", style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold)),
         SizedBox(height: 50,),
          ElevatedButton(
             style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(blue)),
             onPressed: () async {
           Uri url = Uri.parse(link);
           await launchUrl(url,mode: LaunchMode.externalApplication);
         }, child: Padding(
           padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 6),
           child: Text("تنزيل الان",style: TextStyle(fontSize: 22,color: Colors.white),),
         ))
        ],
      )),
    );
  }
}
