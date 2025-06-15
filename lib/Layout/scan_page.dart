import 'package:dirasti/utils/const.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Creates the barcode generator
// class ScanPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//           appBar: AppBar(
//             title: const Text('Barcode Generator Demo'),
//           ),
//           body: Center(
//               child: Container(
//                 height: 200,
//                 child: SfBarcodeGenerator(
//                   value: 'www.syncfusion.com',
//                   symbology: QRCode(),
//                   showValue: true,
//                 ),
//               ))),
//     );
//   }
// }

import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:torch_light/torch_light.dart';


class ScanPage extends StatefulWidget {
  const ScanPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    // FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    return Scaffold(
      body:  Stack(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              _buildQrView(context),
              if(result!=null)
              Column(
                children: [
                  Spacer(),
                  Spacer(),
                  Spacer(),
                  InkWell(
                    onTap: (){
                      Navigator.pop(context,result?.code);
                    },
                    child: Container(
                      decoration: BoxDecoration(color: orange,borderRadius: BorderRadius.circular(15)),
                      width: MediaQuery.of(context).size.width/1.5,
                      height: 50,
                      child: Center(child: Text("بحث",style: TextStyle(fontSize: 20,color: Colors.white),)),
                    ),
                  ),
                  Spacer(),
                ],
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 50),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                  child: Center(
                    child: IconButton(
                        iconSize: 25,
                        onPressed: (){
                          controller!.pauseCamera();
                          controller!.dispose();
                        Navigator.pop(context);
                    }, icon: Icon(Icons.arrow_back_ios_new,color: blue,)),
                  ),
                ),
                Spacer(),
                Text("مسح كود QR",style: TextStyle(fontSize: 25),textDirection: TextDirection.rtl,),
                Spacer(),
                FutureBuilder<bool?>(
                    future: controller?.getFlashStatus(),
                    builder: (context,snapshot){
                    return CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.white,
                      child: Center(
                        child: IconButton(
                            iconSize: 25,
                            onPressed: (){
                          controller?.toggleFlash();
                          setState(() {});
                        }, icon: Icon(snapshot.data! ?Icons.lightbulb_rounded:Icons.lightbulb_outline_rounded,color: orange,)),
                      ),
                    );

                })
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 || MediaQuery.of(context).size.height < 400) ? 250.0 : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(borderColor: blue, borderRadius: 10, borderLength: 30, borderWidth: 10, cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
      // if(scanData.code!=""&&scanData.code!=null){
      //   Navigator.pop(context,scanData.code);
      // }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
