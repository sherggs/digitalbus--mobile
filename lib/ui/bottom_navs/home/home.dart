import 'dart:convert';
import 'dart:io' show Platform;

import 'package:DigiBus/bloc/future_values.dart';
import 'package:DigiBus/database/user-db.dart';
import 'package:DigiBus/ui/bottom_navs/home/new.dart';
import 'package:DigiBus/ui/welcome.dart';
import 'package:DigiBus/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/user.dart';

class Home extends StatefulWidget {
  static const String id = 'home_page';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var publicKey = 'pk_test_6bd7e4b374b54a31d11753b32fe5401c4134bbb5';

  bool fund = false;

  final currencyFormat = new NumberFormat("#,##0.00", "en_US");

  bool loading = false;

  String _firstName = '';
  String _lastName = '';
  String _walletBalance = '0';
  String _userID = '';
  String _email = '';

  /// Instantiating a class of the [FutureValues]
  var futureValues = FutureValues();

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
  final _amount = MoneyMaskedTextController(
    decimalSeparator: '.',
    thousandSeparator: ',',
  );

  void _updateUser() async {
    print('caling update user');
    String url = 'https://digitalbusapi.herokuapp.com//getUser';
    Map<String, String> headers = {"Content-type": "application/json"};
    Map<String, String> body = {
      'userId': _userID,
    };
    Response request = await post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );
    var response = json.decode(request.body);
    print(response);
    if (response['error'] != true) {
      var db = DatabaseHelper();
      print(response['user']);
      User user = User(
        response['user']['userID'],
        response['user']['fullName'],
        response['user']['email'],
        response['user']['walletBalance'],
      );
      await db.saveUser(user);
      setState(() {
        _firstName = response['user']['fullName'].split(' ')[0];
        _lastName = response['user']['fullName'].split(' ')[1];
        _walletBalance = response['user']['walletBalance'];
        _userID = response['user']['userID'];
        _email = response['user']['email'];
      });
    }
  }

  void _getCurrentUser() async {
    await futureValues.getCurrentUser().then((user) {
      if (!mounted) return;
      setState(() {
        _firstName = user.firstName.split(' ')[0];
        _lastName = user.firstName.split(' ')[1];
        _walletBalance = user.walletBalance;
        _userID = user.userID;
        _email = user.email;
      });
      _updateUser();
    }).catchError((Object error) {
      print(error.toString());
    });
  }

  void _fundWallet(int amount) async {
    setState(() {
      loading = true;
    });
    String url = 'https://digitalbusapi.herokuapp.com//fundWallet';
    Map<String, String> headers = {"Content-type": "application/json"};
    Map body = {'userID': _userID, 'amount': amount};
    Response request = await post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );
    var response = json.decode(request.body);
    setState(() {
      loading = false;
      fund = false;
    });
    _amount.text = '0';
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
      _updateWalletBalance(response['balance'].toString());
    }
  }

  void _updateWalletBalance(String walletBalance) {
    var dbHelper = DatabaseHelper();
    dbHelper.updateWalletBalance(walletBalance, _userID);
    _getCurrentUser();
  }

  final plugin = PaystackPlugin();

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
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

  void _makePayment() async {
    int amount = double.parse(
      _amount.text.replaceAll(',', ''),
    ).round();
    if (amount < 100) {
      Fluttertoast.showToast(
        msg: "Minimum amount is ₦100",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      Charge charge = Charge()
        ..amount = amount * 100
        ..reference = _getReference()
        ..email = _email;
      CheckoutResponse response = await plugin.checkout(
        context,
        method: CheckoutMethod.card,
        charge: charge,
      );
      if (response.message == 'Success') {
        _fundWallet(amount);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Hello $_firstName 👋',
                          style: TextStyle(
                            fontFamily: 'Regular',
                            fontSize: 20,
                            color: Color(0xff1dbc92),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.exit_to_app),
                          onPressed: () {
                            _showLogOut(context);
                          },
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: SizeConfig.screenWidth,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        elevation: 5,
                        color: Color(0xff1dbc92),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Wallet Balance',
                                style: TextStyle(
                                  fontFamily: 'Regular',
                                  fontSize: 16,
                                  color: Color(0xffFFFFFF),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Text(
                                    '₦',
                                    style: TextStyle(
                                      fontSize: 36,
                                      color: Color(0xffFFFFFF),
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  Text(
                                    '${currencyFormat.format(double.parse(_walletBalance))}',
                                    style: TextStyle(
                                      fontFamily: 'Regular',
                                      fontSize: 36,
                                      color: Color(0xffFFFFFF),
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              fund
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 15,
                                      ),
                                      child: Container(
                                        width: SizeConfig.screenWidth,
                                        height: 50,
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
                                          controller: _amount,
                                          decoration: kInputDecoration.copyWith(
                                            labelText: 'Amount',
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),
                              Row(
                                children: [
                                  fund
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                            right: 20,
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                fund = false;
                                              });
                                            },
                                            child: Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  15, 8, 15, 8),
                                              color: Colors.white,
                                              child: Text(
                                                'Cancel',
                                                style: TextStyle(
                                                  fontFamily: 'Regular',
                                                  fontSize: 16,
                                                  color: Color(0xff1dbc92),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  GestureDetector(
                                    onTap: () {
                                      if (fund) {
                                        if (!loading) {
                                          _makePayment();
                                        }
                                      } else {
                                        setState(() {
                                          fund = true;
                                        });
                                      }
                                    },
                                    child: Container(
                                      padding:
                                          EdgeInsets.fromLTRB(15, 8, 15, 8),
                                      color: Colors.white,
                                      child: loading
                                          ? Container(
                                              width: 16,
                                              height: 16,
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                ),
                                              ),
                                            )
                                          : Text(
                                              'Fund Wallet',
                                              style: TextStyle(
                                                fontFamily: 'Regular',
                                                fontSize: 16,
                                                color: Color(0xff1dbc92),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 35,
                    ),
                    GestureDetector(
                      onTap: () {
                        // _showTripDetails();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => New(
                              walletBalance: _walletBalance,
                              userId: _userID,
                              fullName: "$_firstName $_lastName",
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
                        width: SizeConfig.screenWidth,
                        decoration: BoxDecoration(
                          color: Color(0xff1dbc92),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'New Trip',
                              style: TextStyle(
                                fontFamily: 'Regular',
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward,
                              size: 20,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
