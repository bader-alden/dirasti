/*
* Other imports
*/
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:huawei_push/huawei_push.dart';


class ad extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<ad> {
  String _token = '';
  void _onTokenEvent(String event) {
    // Requested tokens can be obtained here
    setState(() {
      _token = event;
    });
    print("TokenEvent: " + _token);
  }

  void _onTokenError(Object error) {
    Object e = error;
    print("TokenErrorEvent: " + e.toString());
  }

  @override
  void initState() {
    super.initState();
    initTokenStream();
  }

  Future<void> initTokenStream() async {
    if (!mounted) return;
    Push.getTokenStream.listen(_onTokenEvent, onError: _onTokenError);
  }

  void getToken() {
    // Call this method to request for a token
    Push.getToken("");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(),
      body:Text(_token)
    ));
  }
}