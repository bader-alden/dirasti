import 'package:dirasti/utils/const.dart';
import 'package:dirasti/utils/dio.dart';
import 'package:flutter/material.dart';
String _terms = "";
class Terms extends StatefulWidget {
  const Terms({Key? key}) : super(key: key);

  @override
  _TermsState createState() => _TermsState();
}

class _TermsState extends State<Terms> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dio.get_data(url:"/data/privacy_policy").then((value){
      _terms = value?.data[0]["text"];
      setState(() {});
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar_back("سياسة الخصوصية و الاستخدام"),
      body: _terms ==""
            ?Center(child: CircularProgressIndicator())
            :SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(padding: EdgeInsets.all(8),width: double.infinity,child: Text(_terms,style: TextStyle(fontSize: 16),textDirection: TextDirection.rtl)),
      ),
    );
  }
}
