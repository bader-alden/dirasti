import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../utils/const.dart';

class Pdf extends StatelessWidget {
  const Pdf({Key? key, this.link, this.title}) : super(key: key);
final link;
final title;
  @override
  Widget build(BuildContext context) {
    FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    return Scaffold(
       appBar: appbar_back(title),
      body:  Container(
          child: SfPdfViewer.network(
              link, enableTextSelection: false,))
    );
  }
}
