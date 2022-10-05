import 'dart:io' show Platform;
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:http/http.dart';
import 'package:DigiBus/ui/bottom_navs/home/success.dart';
import 'package:DigiBus/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TripDetails extends StatefulWidget {
  static const String id = 'trip_details_page';

  TripDetails({
    this.tripID,
    this.origin,
    this.destination,
    this.price,
    this.time,
    this.userId,
    this.fullName,
    this.walletBalance,
  });

  final String tripID;
  final String origin;
  final String destination;
  final String price;
  final String time;
  final String userId;
  final String fullName;
  final String walletBalance;

  @override
  _TripDetailsState createState() => _TripDetailsState();
}

class _TripDetailsState extends State<TripDetails> {
  bool _showSpinner = false;
  TextEditingController _dateOfTrip = new TextEditingController();
  bool _loading = false;

  var publicKey = 'pk_test_6bd7e4b374b54a31d11753b32fe5401c4134bbb5';

  final plugin = PaystackPlugin();

  @override
  void initState() {
    super.initState();
    _dateOfTrip.text = 'Today';
    plugin.initialize(
      publicKey: publicKey,
    );
  }

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }
    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  void _makePayment() async {
    Charge charge = Charge()
      ..amount = int.parse(widget.price) * 100
      ..reference = _getReference()
      ..email = 'akinthope@email.com';
    CheckoutResponse response = await plugin.checkout(
      context,
      method: CheckoutMethod.card,
      charge: charge,
    );
    if (response.message == 'Success') {
      _makeBooking();
    }
  }

  void _makeBooking() async {
    setState(() {
      _loading = true;
    });
    String url = 'https://digitalbusapi.herokuapp.com//createBooking';
    Map<String, String> headers = {"Content-type": "application/json"};
    DateTime newDate = DateTime.now();
    String today = newDate.day.toString() +
        '/' +
        newDate.month.toString() +
        '/' +
        newDate.year.toString();
    Map body = {
      'userID': widget.userId,
      'userId': widget.userId,
      'tripID': widget.tripID,
      'fullName': widget.fullName,
      "tripName": "${widget.origin} to ${widget.destination}",
      'amountPaid': widget.price,
      'viaWallet': false,
      'tripTime': widget.time,
      'dateOfTrip': _dateOfTrip.text == 'Today' ? today : _dateOfTrip.text,
    };
    Response request = await post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );
    var response = json.decode(request.body);
    setState(() {
      _loading = false;
    });
    if (response['error'] == true) {
      Fluttertoast.showToast(
        msg: response['msg'],
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      Navigator.pushAndRemoveUntil<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => Success(
            date: _dateOfTrip.text,
            amount: widget.price,
            origin: widget.origin,
            destination: widget.destination,
          ),
        ),
        (route) => false,
      );
    }
  }

  void _payViaWallet() async {
    if (double.parse(widget.walletBalance) < double.parse(widget.price)) {
      Fluttertoast.showToast(
        msg: 'Insufficient wallet balance',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }
    setState(() {
      _showSpinner = true;
    });
    String url = 'https://digitalbusapi.herokuapp.com//createBooking';
    Map<String, String> headers = {"Content-type": "application/json"};
    DateTime newDate = DateTime.now();
    String today = newDate.day.toString() +
        '/' +
        newDate.month.toString() +
        '/' +
        newDate.year.toString();
    Map body = {
      'userID': widget.userId,
      'userId': widget.userId,
      'tripID': widget.tripID,
      'fullName': widget.fullName,
      "tripName": "${widget.origin} to ${widget.destination}",
      'amountPaid': widget.price,
      'tripTime': widget.time,
      'viaWallet': true,
      'dateOfTrip': _dateOfTrip.text == 'Today' ? today : _dateOfTrip.text,
    };
    Response request = await post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );
    var response = json.decode(request.body);
    setState(() {
      _showSpinner = false;
    });
    print(response);
    if (response['error'] == true) {
      Fluttertoast.showToast(
        msg: response['msg'],
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      Navigator.pushAndRemoveUntil<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => Success(
            date: _dateOfTrip.text,
            amount: widget.price,
            origin: widget.origin,
            destination: widget.destination,
          ),
        ),
        (route) => false,
      );
    }
  }

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
      color: Color(0xFFFFFFFF).withOpacity(0.24),
    ),
  );

  ///Display the modal for date of birth
  Widget _datetimePicker() {
    return CupertinoDatePicker(
      initialDateTime: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        DateTime.now().hour + 1,
      ),
      onDateTimeChanged: (DateTime newDate) {
        setState(() {
          _dateOfTrip.text = newDate.day.toString() +
              '/' +
              newDate.month.toString() +
              '/' +
              newDate.year.toString();
        });
      },
      maximumDate: DateTime(DateTime.now().year, DateTime.now().month + 1),
      minimumDate: DateTime.now(),
      mode: CupertinoDatePickerMode.date,
    );
  }

  final currencyFormat = new NumberFormat("#,##0.00", "en_US");

  ///Show the bottom modal sheet for the date picker
  Future<void> _bottomSheet(BuildContext context, Widget child) {
    return showModalBottomSheet(
      isScrollControlled: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(13),
          topRight: Radius.circular(13),
        ),
      ),
      backgroundColor: Colors.white,
      context: context,
      builder: (context) => Container(
        height: SizeConfig.screenHeight * 0.4,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      decoration: BoxDecoration(
        color: Color(0xff1dbc92),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 50,
                height: 6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'Trip Details',
              style: TextStyle(
                fontFamily: 'Regular',
                fontSize: 26,
                color: Color(0xffFFFFFF),
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      '${widget.origin}',
                      style: TextStyle(
                        fontFamily: 'Regular',
                        fontSize: 16,
                        color: Color(0xffFFFFFF),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Transform.rotate(
                        angle: 1.6,
                        child: Icon(
                          Icons.compare_arrows,
                          size: 26,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${widget.destination}',
                      style: TextStyle(
                        fontFamily: 'Regular',
                        fontSize: 16,
                        color: Color(0xffFFFFFF),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 45,
                ),
                Image.asset(
                  'assets/images/bus.png',
                  width: SizeConfig.screenWidth * 0.4,
                  fit: BoxFit.contain,
                ),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              children: [
                Icon(
                  Icons.timer,
                  size: 18,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  '${widget.time}',
                  style: TextStyle(
                    fontFamily: 'Regular',
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Icon(
                  Icons.money,
                  size: 18,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  '₦${currencyFormat.format(double.parse(widget.price))}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 35,
            ),
            GestureDetector(
              onTap: () {
                _bottomSheet(context, _datetimePicker());
              },
              child: Container(
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
                  keyboardType: TextInputType.phone,
                  enabled: false,
                  controller: _dateOfTrip,
                  decoration: kInputDecoration.copyWith(
                    labelText: 'Date of Trip',
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 45,
            ),
            GestureDetector(
              onTap: () {
                _payViaWallet();
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
                width: SizeConfig.screenWidth,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: _showSpinner
                      ? CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        )
                      : Text(
                          'Pay ₦${currencyFormat.format(double.parse(widget.price))} Via Wallet',
                          style: TextStyle(
                            fontFamily: 'Regular',
                            fontSize: 18,
                            color: Color(0xff1dbc92),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            GestureDetector(
              onTap: () {
                _makePayment();
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
                width: SizeConfig.screenWidth,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: _loading
                      ? CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        )
                      : Text(
                          'Pay ₦${currencyFormat.format(double.parse(widget.price))} From Card',
                          style: TextStyle(
                            fontFamily: 'Regular',
                            fontSize: 18,
                            color: Color(0xff1dbc92),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
          ],
        ),
      ),
    );
  }
}
