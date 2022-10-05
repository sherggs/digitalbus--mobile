import 'dart:convert';

import 'package:DigiBus/bloc/future_values.dart';
import 'package:DigiBus/database/user-db.dart';
import 'package:DigiBus/ui/bottom_navs/ticketPage.dart';
import 'package:DigiBus/ui/welcome.dart';
import 'package:DigiBus/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class History extends StatefulWidget {
  static const String id = 'history_page';

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  /// Instantiating a class of the [FutureValues]
  var futureValues = FutureValues();

  final currencyFormat = new NumberFormat("#,##0.00", "en_US");

  bool loading = true;

  String _userID = '';

  List trips = [];

  /// Function to logout your account
  void _logout() async {
    var db = DatabaseHelper();
    await db.deleteUsers();
    _getBoolValuesSF();
  }

  /// Function to get the 'loggedIn' in your SharedPreferences
  _getBoolValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool boolValue = prefs.getBool('loggedIn') ?? true;
    if (boolValue == true) {
      _addBoolToSF();
    }
  }

  /// Function to set the 'loggedIn' in your SharedPreferences to false
  _addBoolToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loggedIn', false);
    Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => Welcome(),
      ),
      (route) => false,
    );
  }

  _showLogOut(context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          'Log Out',
          style: TextStyle(
            fontFamily: 'Regular',
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              'You are about to log out from the application',
              style: TextStyle(
                fontFamily: 'Regular',
                fontSize: 18,
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Regular',
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  color: Color(0xff1dbc92),
                  child: Text(
                    'Log Out',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Regular',
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                  onPressed: () {
                    _logout();
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void _getCurrentUser() async {
    await futureValues.getCurrentUser().then((user) {
      _userID = user.userID;
      _getBookingHistory();
    }).catchError((Object error) {
      print(error.toString());
    });
  }

  void _getBookingHistory() async {
    setState(() {
      loading = true;
    });
    String url = 'https://digitalbusapi.herokuapp.com//getBookings';
    Map<String, String> headers = {"Content-type": "application/json"};
    Map body = {'userID': _userID};
    Response request = await post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );
    var response = json.decode(request.body);
    setState(() {
      loading = false;
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
      setState(() {
        trips = response['trips'] == null ? [] : response['trips'];
        print(trips);
      });
    }
  }

  void initState() {
    super.initState();
    _getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Transform.translate(
          offset: Offset(0, 0),
          child: Container(
            width: 160,
            height: 62,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
              elevation: 5,
              child: Center(
                child: Text(
                  'History',
                  style: TextStyle(
                    fontFamily: 'Regular',
                    fontSize: 16,
                    color: Color(0xff1dbc92),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
        centerTitle: false,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 25, 0),
            child: IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                _showLogOut(context);
              },
            ),
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
                  child: Text(
                    'Trip History',
                    style: TextStyle(
                      fontFamily: 'Regular',
                      fontSize: 20,
                      color: Color(0xff000000),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 25),
                loading
                    ? Padding(
                        padding: const EdgeInsets.only(
                          top: 30,
                        ),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : trips.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(
                              top: 30,
                            ),
                            child: Center(
                              child: Text(
                                'You have not made any trips',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Regular',
                                  fontSize: 18,
                                  color: Color(0xff1dbc92),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (var trip in trips)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => TicketPage(
                                            date: trip['dateOfTrip'],
                                            destination: trip['tripName']
                                                .split(' to ')[1],
                                            origin: trip['tripName']
                                                .split(' to ')[0],
                                            amount:
                                                '${currencyFormat.format(double.parse(trip['amountPaid']))}',
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 5, 10, 5),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            width: 1,
                                            color: Color(0XFFCCCCCC),
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${trip['tripName']}',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontFamily: 'Regular',
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xff1dbc92),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '₦${currencyFormat.format(double.parse(trip['amountPaid']))} ',
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      fontFamily: 'Regular',
                                                      fontSize: 14,
                                                      color: Color(0xff1dbc92),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Text(
                                                    '${trip['tripTime']}',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'Circular Std Book',
                                                      color: Color(0xFFA9A5AF),
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                            ],
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.black,
                                            size: 16,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
