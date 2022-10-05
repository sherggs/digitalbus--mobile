import 'dart:convert';
import 'dart:io' show Platform;

import 'package:DigiBus/ui/bottom_navs/home/tripDetails.dart';
import 'package:DigiBus/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class New extends StatefulWidget {
  static const String id = 'new_page';

  New({this.walletBalance, this.userId, this.fullName});

  final String walletBalance;
  final String userId;
  final String fullName;

  @override
  _NewState createState() => _NewState();
}

class _NewState extends State<New> {
  InputDecoration kInputDecoration = InputDecoration(
    labelStyle: TextStyle(
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.normal,
      fontSize: 18,
      fontFamily: 'Regular',
      color: Color(0XFFFFFFFF),
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide(
        color: Color(0XFFFFFFFF),
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Color(0XFFFFFFFF),
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Color(0XFFFFFFFF),
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Color(0XFFFFFFFF),
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
    ),
    hintStyle: TextStyle(
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.normal,
      fontSize: 14,
      fontFamily: 'Regular',
      color: Color(0XFFFFFFFF),
    ),
  );

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController controller;

  bool loading = false;

  TextEditingController _tripID = new TextEditingController();

  ///Modal to display the trip's details
  _showTripDetails(Map tripDetails) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => TripDetails(
        tripID: tripDetails['tripID'],
        origin: tripDetails['origin'],
        destination: tripDetails['destination'],
        price: tripDetails['price'],
        time: tripDetails['time'],
        userId: widget.userId,
        fullName: widget.fullName,
        walletBalance: widget.walletBalance,
      ),
    );
  }

  void _getTrip() async {
    if (_tripID.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Invalid Trip ID",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      setState(() {
        loading = true;
      });
      String url = 'https://digitalbusapi.herokuapp.com//getTrip';
      Map<String, String> headers = {"Content-type": "application/json"};
      Map body = {'tripID': _tripID.text};
      Response request = await post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );
      var response = json.decode(request.body);
      setState(() {
        loading = false;
      });
      print(response);
      if (response['error'] == true) {
        Fluttertoast.showToast(
          msg: response['msg'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        _showTripDetails(response['trip']);
      }
    }
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    } else if (Platform.isIOS) {
      controller.resumeCamera();
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        _tripID.text = scanData.code;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Color(0xff1dbc92),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xff1dbc92),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 18,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                width: SizeConfig.screenWidth,
                height: SizeConfig.screenWidth - 30,
                color: Colors.blueGrey,
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Scan QR Code',
                style: TextStyle(
                  fontFamily: 'Regular',
                  fontSize: 20,
                  color: Color(0xffFFFFFF),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 75,
              ),
              Container(
                width: SizeConfig.screenWidth,
                child: TextFormField(
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                    fontSize: 18,
                    fontFamily: 'Regular',
                    color: Color(0xFFFFFFFF),
                  ),
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,
                  controller: _tripID,
                  decoration: kInputDecoration.copyWith(
                    labelText: 'Trip ID',
                  ),
                ),
              ),
              SizedBox(
                height: 35,
              ),
              RaisedButton(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 60,
                  child: Center(
                    child: loading
                        ? CircularProgressIndicator()
                        : Text(
                            "GET TRIP",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Circular',
                              color: Color(0xff1dbc92),
                            ),
                          ),
                  ),
                ),
                color: Colors.white,
                onPressed: () {
                  _getTrip();
                },
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
