import 'package:dirasti/main.dart';
import 'package:dirasti/module/user_module.dart';
import 'package:dirasti/utils/cache.dart';
import 'package:dirasti/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Bloc/user/user_bloc.dart';
import '../Bloc/user/user_bloc.dart';

var _number_con = TextEditingController();
var _name_con = TextEditingController();
var _sex_con = ['أنثى', 'ذكر'];
var _sex_value = null;
var _grade = "";
bool _is_check = false;
bool init = false;

class Signin extends StatelessWidget {
  const Signin({Key? key, this.type, this.data}) : super(key: key);
  final type;
  final user_module? data;
  @override
  Widget build(BuildContext context) {
    var is_loadin = false;
    if (!init && type == "edit") {
      init = true;
    _sex_value = _sex_con[data!.is_male! ? 1 : 0];
    _number_con.text = data!.mobile_id!;
    _name_con.text = data!.name!;
    _grade = data!.grade!;
    }
    return BlocProvider(
      create: (context) => UserBloc()..add(grade_init()),
      child: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state is scss_signin) {
            // cache.save_data("id", "3");
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => App(),
                ),
                (route) => false);
          }
          if (state is error_signin) {
            print(state.error);
            is_loadin = false;
            Tost(state.error, Colors.red);
          }
          if(state is scss_update_state){
            Tost("تم التعديل بنجاح", Colors.green);
            Navigator.pop(context);
          }
        },
        builder: (context, state) {

          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Card(child: BackButton(color: blue), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), elevation: 1),
                        Spacer(),
                        Image.asset("assets/onboard_logo.jpg", width: 100),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: ListView(
                        physics: BouncingScrollPhysics(),
                        //crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            type == "edit" ? "تعديل الحساب" : "إنشاء حساب",
                            style: TextStyle(color: blue, fontSize: 22, fontWeight: FontWeight.bold),
                            textDirection: TextDirection.rtl,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "الاسم",
                            style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                            textDirection: TextDirection.rtl,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                              decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(10)),
                              child: TextFormField(
                                textDirection: TextDirection.rtl,
                                decoration: InputDecoration(border: InputBorder.none),
                                keyboardType: TextInputType.name,
                                style: TextStyle(fontSize: 20),
                                controller: _name_con,
                              )),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "رقم الهاتف",
                            style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                            textDirection: TextDirection.rtl,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Center(
                                    child: Text(
                                  "09",
                                  style: TextStyle(fontSize: 20),
                                )),
                                Expanded(
                                    child: TextFormField(
                                  decoration: InputDecoration(border: InputBorder.none),
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(fontSize: 20),
                                  controller: _number_con,
                                      inputFormatters: [FilteringTextInputFormatter.digitsOnly,LengthLimitingTextInputFormatter(8)],
                                )),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text("الجنس",
                              style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold), textDirection: TextDirection.rtl),
                          SizedBox(
                            height: 10,
                          ),
                          StatefulBuilder(builder: (context, setstatae) {
                            return Container(
                              decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: DropdownButton(
                                    items: _sex_con.map(drop_item).toList(),
                                    onChanged: (value) {
                                      setstatae(() {
                                        _sex_value = value;
                                      });
                                    },
                                    value: _sex_value ?? _sex_con[0],
                                    isExpanded: true,
                                    alignment: Alignment.centerRight,
                                    underline: Text(""),
                                  ),
                                ),
                              ),
                            );
                          }),
                          SizedBox(
                            height: 20,
                          ),
                          Text("الصف الدراسي",
                              style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold), textDirection: TextDirection.rtl),
                          SizedBox(
                            height: 10,
                          ),
                          if (context.read<UserBloc>().grade_modules.length == 0)
                            SizedBox(
                              child: Center(child: CircularProgressIndicator()),
                              height: 40,
                              width: 20,
                            )
                          else
                            StatefulBuilder(builder: (context, setstatea) {
                              return Container(
                                decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: DropdownButton(
                                      items: context.read<UserBloc>().grade_modules.map((e)=>DropdownMenuItem(child: Text(e.name!, textDirection: TextDirection.rtl),value: e.id,)).toList(),
                                      onChanged: (value) {
                                        setstatea(() {
                                          _grade =value.toString();
                                        });
                                      },
                                      value: _grade,
                                      isExpanded: true,
                                      alignment: Alignment.centerRight,
                                      underline: Text(""),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          SizedBox(
                            height: 20,
                          ),
                          if (type != "edit")
                            StatefulBuilder(builder: (context, setstatea) {
                              return Row(
                                children: [
                                  Spacer(),
                                  TextButton(
                                      onPressed: () {},
                                      child: Text("سياسة الخصوصية", style: TextStyle(fontSize: 11), textDirection: TextDirection.rtl)),
                                  Text("الضغط على إنشاء الحساب تعني الموافقة على", style: TextStyle(fontSize: 11), textDirection: TextDirection.rtl),
                                  Checkbox(
                                      value: _is_check,
                                      onChanged: (value) {
                                        setstatea(() {
                                          _is_check = !_is_check;
                                        });
                                      },
                                      fillColor: MaterialStatePropertyAll(blue)),
                                ],
                              );
                            }),
                          SizedBox(
                            height: 10,
                          ),
                          if (type == "edit")
                            StatefulBuilder(builder: (context, statee) {
                              return TextButton(
                                onPressed: () {
                                  if (_name_con.text.length > 1 && _number_con.text.length == 8 && !is_loadin) {
                                    statee(() {
                                      is_loadin = true;
                                      context
                                          .read<UserBloc>()
                                          .add(user_update(_name_con.text, "aaaaaa", _number_con.text, _sex_con.indexOf(_sex_value), _grade));
                                    });
                                  } else {
                                    if (_name_con.text.length < 1) {
                                      Tost("لايمكن ان يكون الاسم فارغا", Colors.red);
                                    } else if (_number_con.text.length != 8) {
                                      Tost("يرجى إدخال رقم جوال صالح", Colors.red);
                                    }
                                  }
                                },
                                child: AnimatedContainer(
                                    duration: Duration(milliseconds: 300),
                                    width: is_loadin ? 60:MediaQuery.of(context).size.width/1.2,
                                    height: 60,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: blue),
                                    child: Center(
                                        child: is_loadin
                                            ? CircularProgressIndicator(color: Colors.white,)
                                            : Text("تعديل حساب", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)))),
                              );
                            })
                          else
                            StatefulBuilder(builder: (context, statee) {
                              return TextButton(
                                onPressed: () {
                                  if (_is_check && _name_con.text.length > 1 && _number_con.text.length == 8 && !is_loadin) {
                                    statee(() {
                                      is_loadin = true;
                                      context
                                          .read<UserBloc>()
                                          .add(user_signin(_name_con.text, "aaaaaa", _number_con.text, _sex_con.indexOf(_sex_value), _grade));
                                    });
                                  } else {
                                    if (!_is_check) {
                                      Tost("يرجى الموافقة على سياسة الخصوصية", Colors.red);
                                    } else if (_name_con.text.length < 1) {
                                      Tost("لايمكن ان يكون الاسم فارغا", Colors.red);
                                    } else if (_number_con.text.length != 8) {
                                      Tost("يرجى إدخال رقم جوال صالح", Colors.red);
                                    }
                                  }
                                },
                                child:  AnimatedContainer(
                                    duration: Duration(milliseconds: 300),
                                    width: is_loadin ? 60:MediaQuery.of(context).size.width/1.2,
                                    height: 60,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: blue),
                                    child: Center(
                                        child: is_loadin
                                            ? CircularProgressIndicator(color: Colors.white,)
                                            : Text("إنشاء حساب", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)))),
                              );
                            }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  DropdownMenuItem drop_item(item) => DropdownMenuItem(
      alignment: Alignment.centerRight,
      value: item,
      child: Text(
        item,
        maxLines: 1,
        textDirection: TextDirection.rtl,
        overflow: TextOverflow.ellipsis,
      ));
}
