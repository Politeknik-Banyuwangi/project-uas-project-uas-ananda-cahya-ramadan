import 'dart:io';
import 'dart:developer';
import 'package:flutter_login/model/absen.dart';
import 'package:flutter_login/services/apiabsen.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class QrViewExample extends StatefulWidget {
  QrViewExample({Key? key}) : super(key: key);

  @override
  State<QrViewExample> createState() => _QrViewExampleState();
}

class _QrViewExampleState extends State<QrViewExample> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String email = '';
  Undangan? undangan;
  ApiUndangan? apiUndangan;

  @override
  void initState() {
    super.initState();
    apiUndangan = ApiUndangan();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  Widget build(BuildContext context) {
    if (result != null) email = result!.code;
    return Scaffold(
      body: Column(
        children: <Widget>[
          if (result == null)
            Expanded(flex: 4, child: _buildQRView(context))
          else
            FutureBuilder<Undangan?>(
                future: apiUndangan!.cekUndangan(email),
                builder:
                    (BuildContext context, AsyncSnapshot<Undangan?> snapshot) {
                  if (snapshot.hasData) {
                    print(snapshot.data!.nama);
                    apiUndangan!.updateKehadiran(snapshot.data!);
                    return _profil(snapshot.data!);
                  } else if (snapshot.hasError) {
                    print("Error Snapshot ${snapshot.data}");
                    return Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 100),
                      child: Text(
                        "Data Tidak Ditemukan",
                        style: TextStyle(fontSize: 20, color: Colors.red),
                      ),
                    );
                  } else
                    return CircularProgressIndicator();
                }),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (result != null)
                    Text(
                        'Barcode Type: ${describeEnum(result!.format)} Data: ${result!.code}')
                  else
                    Text("Scan a code"),
                  Container(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          result = null;
                        });
                      },
                      child: Text("Coba Lagi"),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: (() async {
                            await controller?.toggleFlash();
                            setState(() {});
                          }),
                          child: FutureBuilder(
                              future: controller?.getFlashStatus(),
                              builder: (context, snapsot) {
                                return Text('Flash : ${snapsot.data}');
                              }),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(0),
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller?.flipCamera();
                          },
                          child: FutureBuilder(
                              future: controller?.getCameraInfo(),
                              builder: (context, snapshot) {
                                if (snapshot.data != null) {
                                  return Text(
                                      'Camera Facing ${describeEnum(snapshot.data!)}');
                                } else {
                                  return Text('Loading');
                                }
                              }),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(0),
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller?.pauseCamera();
                          },
                          child: Text('pause', style: TextStyle(fontSize: 20)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(8),
                        child: ElevatedButton(
                            onPressed: () async {
                              await controller?.resumeCamera();
                            },
                            child: Text(
                              'resume',
                              style: TextStyle(fontSize: 20),
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQRView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 400.0
        : 400.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
    );
  }

  Widget _profil(Undangan undangan) {
    return Container(
      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
      margin: EdgeInsets.fromLTRB(10, 50, 10, 50),
      color: Colors.purple.withOpacity(0.5),
      child: Column(children: [
        Text(
          "${undangan.nama}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 20),
        Container(
          child: Image.network(
              "http://mhs.rey1024.com/apiundangan/${undangan.foto}"),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "Terimakasih sudah hadir",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.amber,
          ),
        )
      ]),
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
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
