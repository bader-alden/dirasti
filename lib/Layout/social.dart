import 'package:dirasti/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:dirasti/utils/dio.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:url_launcher/url_launcher.dart';
List list_social = [];
class Social extends StatefulWidget {
  const Social({Key? key}) : super(key: key);

  @override
  _SocialState createState() => _SocialState();
}

class _SocialState extends State<Social> {
  @override
  void initState() {
    dio.get_data(url: "/data/Social_Media",).then((value) {
      list_social.clear();
      value?.data.forEach((e){
        list_social.add(e);
        if(list_social.length -1 == value?.data.indexOf(e)){
          setState(() {});
        }
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    return Scaffold(
      appBar: appbar_back("التواصل الاجتماعي"),
      body: list_social.isEmpty
        ?Center(child: CircularProgressIndicator(),)
        :ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: list_social.length,
          itemBuilder: (context,index){
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(child: InkWell(
              onTap: (){
                launchUrl(Uri.parse(list_social[index]["link"]),mode:LaunchMode.externalNonBrowserApplication );
              },
              borderRadius: BorderRadius.circular(100),
              child: Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),elevation: 2,child: Padding(
                padding: const EdgeInsets.all(20),
                child: Image.network(list_social[index]["photo"],width: 75,height: 75,),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
