import 'package:dirasti/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'scan_page.dart';
var node_1 = FocusNode();
var node_2 = FocusNode();
var node_3 = FocusNode();
var text_con1=TextEditingController();
var text_con2=TextEditingController();
var text_con3=TextEditingController();
class AddCourse extends StatelessWidget {
  const AddCourse({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: white,
        actions: [
          Row(
            children: [
              Text("الدفع",style: TextStyle(color: blue,fontSize: 24),),
              SizedBox(width: 5,),
            ],
          )
        ],
      ),
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: ListView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                children: [
                  // SizedBox(height: 50,),
                  // Text("الدفع",style: TextStyle(color: blue,fontSize: 22)),
                  SizedBox(height: 20,),
                  // Center(
                  //     child: QrImage(
                  //       data: "شكرا لإستخدامك تطبيق دراستي" ,
                  //       dataModuleStyle: QrDataModuleStyle(dataModuleShape: QrDataModuleShape.circle,color: Colors.black),
                  //       eyeStyle: QrEyeStyle(eyeShape: QrEyeShape.values[0],color: Colors.black),
                  //       version: QrVersions.auto,
                  //       size: 250,
                  //       gapless: true,
                  //       embeddedImage: AssetImage('assets/qr_logo.jpg'),
                  //       embeddedImageStyle: QrEmbeddedImageStyle(
                  //         size: Size(80, 80),
                  //       ),
                  //     )
                  // ),
                  Center(child: Image.asset("assets/qr.png",height: 250),),
                  //Center(child: Icon(Icons.qr_code,size: 300,)),
                  SizedBox(height: 20,),
                  Center(child: Text("إدخال كود التفعيل او قم بمسح الكود لشراءه",style: TextStyle(color: blue,fontSize: 20),textDirection: TextDirection.rtl)),
                  SizedBox(height: 20,),
                  Center(child: InkWell(onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ScanPage()));
                  }, child: Container(width: 200,height: 50,decoration:BoxDecoration(color: orange,borderRadius: BorderRadius.circular(10)),child: Center(child: Text("مسح الكود",style: TextStyle(color: Colors.white,fontSize: 18),))))),
                  SizedBox(height: 20,),
                  Text("إدخال الرمز",style: TextStyle(color: blue,fontSize: 22),textDirection: TextDirection.rtl),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: InkWell(
                          onTap: (){
                            SystemChannels.textInput.invokeMethod("TextInput.show");
                            FocusScope.of(context).unfocus();
                             if(text_con1.text.length==3&&text_con2.text.length==3&&text_con3.text.isNotEmpty) {
                            FocusScope.of(context).requestFocus(node_3);
                            }
                            else if(text_con1.text.length==3&&text_con2.text.isNotEmpty&&text_con3.text.isEmpty) {
                              FocusScope.of(context).requestFocus(node_2);
                            }else if(text_con2.text.isEmpty&&text_con3.text.isEmpty) {
                            FocusScope.of(context).requestFocus(node_1);
                            }
                          },
                          child: IgnorePointer(
                            ignoring:true ,
                            child: Row(
                              children: [
                                Expanded(child: InkWell(overlayColor: MaterialStatePropertyAll(Colors.transparent),hoverColor: Colors.transparent,onTap: (){FocusScope.of(context).requestFocus(node_1);},child: Container(color: Colors.transparent,width: double.infinity,height: 50,))),
                                Expanded(
                                  flex: 3,
                                  child: TextFormField(
                                    controller: text_con1,
                                    //textDirection: TextDirection.rtl,
                                    style: TextStyle(fontSize: 22),
                                    decoration: InputDecoration(border: InputBorder.none),
                                    focusNode: node_1,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(3),
                                      TextFieldNavigator(context: context,focusNodePrev: node_1,focusNodeNext: node_2,first_node: node_1)
                                    ],
                                  ),
                                ),
                                Expanded(child: InkWell(overlayColor: MaterialStatePropertyAll(Colors.transparent),hoverColor: Colors.transparent,onTap: (){FocusScope.of(context).requestFocus(node_1);},child: Container(color: Colors.transparent,width: double.infinity,height: 50,))),
                                 Text("-",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22)),
                                Expanded(child: InkWell(overlayColor: MaterialStatePropertyAll(Colors.transparent),hoverColor: Colors.transparent,onTap: (){FocusScope.of(context).requestFocus(node_2);},child: Container(color: Colors.transparent,width: double.infinity,height: 50,))),
                                Expanded(
                                  flex: 3,
                                  child: TextFormField(
                                    decoration: InputDecoration(border: InputBorder.none),
                                    controller: text_con2,
                                    // textDirection: TextDirection.rtl,
                                    style: TextStyle(fontSize: 22),
                                    focusNode: node_2,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(3),
                                      TextFieldNavigator(context: context,focusNodePrev: node_1,focusNodeNext: node_3,first_node: node_1)
                                    ],
                                  ),
                                ),
                                Expanded(child: InkWell(overlayColor: MaterialStatePropertyAll(Colors.transparent),hoverColor: Colors.transparent,onTap: (){FocusScope.of(context).requestFocus(node_2);},child: Container(color: Colors.transparent,width: double.infinity,height: 50,))),
                                Text("-",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22)),

                                Expanded(child: InkWell(overlayColor: MaterialStatePropertyAll(Colors.transparent),hoverColor: Colors.transparent,onTap: (){FocusScope.of(context).requestFocus(node_3);},child: Container(color: Colors.transparent,width: double.infinity,height: 50,))),
                                Expanded(
                                  flex: 3,
                                  child: TextFormField(
                                    controller: text_con3,
                                   // textDirection: TextDirection.rtl,
                                    style: TextStyle(fontSize: 22),
                                    decoration: InputDecoration(border: InputBorder.none),
                                    focusNode: node_3,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(3),
                                      TextFieldNavigator(context: context,focusNodePrev: node_2,focusNodeNext: node_3,first_node: node_1)
                                    ],
                                  ),
                                ),
                                Expanded(child: InkWell(overlayColor: MaterialStatePropertyAll(Colors.transparent),hoverColor: Colors.transparent,onTap: (){FocusScope.of(context).requestFocus(node_3);},child: Container(color: Colors.transparent,width: double.infinity,height: 50,))),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            InkWell(onTap: (){
            }, child: Container(width: double.infinity,height: 50,decoration:BoxDecoration(color: blue,borderRadius: BorderRadius.circular(10)),child: Center(child: Text("شراء الكورس",style: TextStyle(color: Colors.white,fontSize: 18),)))),
            SizedBox(height: 20,),

          ],
        ),
      ),
    );
  }
}



class TextFieldNavigator extends TextInputFormatter {
  final FocusNode focusNodeNext;
  final FocusNode focusNodePrev;
  final BuildContext context;
  final FocusNode first_node;

  TextFieldNavigator({
    required this.context,
    required this.focusNodeNext,
    required this.focusNodePrev,
    required this.first_node,
  }) {
    assert(context != null);

    assert(focusNodeNext != null);
    assert(focusNodePrev != null);
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (oldValue.text.length == 2 && newValue.text.length == 3) {
      FocusScope.of(context).requestFocus(focusNodeNext);
    } else if (oldValue.text.length == 1 && newValue.text.length == 0) {
      FocusScope.of(context).requestFocus(focusNodePrev);
    }else if (newValue.text.length == 3 ) {
      FocusScope.of(context).requestFocus(focusNodeNext);
    }
    return newValue;
  }
}