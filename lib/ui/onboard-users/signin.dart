import 'dart:convert';

import 'package:DigiBus/database/user-db.dart';
import 'package:DigiBus/model/user.dart';
import 'package:DigiBus/ui/index.dart';
import 'package:DigiBus/ui/onboard-users/signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  static const String id = 'sign_in_page';

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool showPassword = false;
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  bool loading = false;

  var _formKey = GlobalKey<FormState>();

  void logIn() async {
    setState(() {
      loading = true;
    });
    String url = 'https://digitalbusapi.herokuapp.com//logIn';
    Map<String, String> headers = {"Content-type": "application/json"};
    Map<String, String> body = {
      'email': email.text,
      'password': password.text,
    };
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
      var db = DatabaseHelper();
      User user = User(
        response['user']['userID'],
        response['user']['fullName'],
        response['user']['email'],
        response['user']['walletBalance'],
      );
      await db.saveUser(user);
      _addBoolToSF(true);
    }
  }

  /// This function adds a [state] boolean value to the device
  /// [SharedPreferences] logged in
  _addBoolToSF(bool state) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loggedIn', state);
    Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => Index(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(26, 0, 0, 10),
                  child: Text(
                    'Login!',
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'Circular',
                      color: Color.fromRGBO(0, 189, 144, 1),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(26, 21, 26, 10),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 75,
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: email,
                      validator: (value) {
                        if (!value.contains('@') || value.length < 4) {
                          return "Invalid Email";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(5),
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Circular',
                          color: Color.fromRGBO(95, 95, 95, 1),
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Circular',
                        color: Color.fromRGBO(95, 95, 95, 1),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(26, 22, 26, 5),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 75,
                    child: TextFormField(
                      controller: password,
                      obscureText: !showPassword,
                      validator: (value) {
                        if (value.length < 6) {
                          return "Password must be at least 6 characters";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(5),
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          icon: (showPassword)
                              ? Icon(Icons.visibility)
                              : Icon(Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                        ),
                        labelStyle: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Circular',
                          color: Color.fromRGBO(95, 95, 95, 1),
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Circular',
                        color: Color.fromRGBO(95, 95, 95, 1),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 0, 26, 0),
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Color.fromRGBO(0, 189, 144, 1),
                      fontFamily: 'Circular',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 25, 0, 26),
                  child: Center(
                    child: RaisedButton(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: 60,
                        child: Center(
                          child: loading
                              ? CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                )
                              : Text(
                                  "LOGIN",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Circular',
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                      color: Color.fromRGBO(0, 189, 144, 1),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          logIn();
                        }
                      },
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "New User? ",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Circular',
                            color: Color.fromRGBO(95, 95, 95, 1),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              SignUp.id,
                            );
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Circular',
                              color: Color.fromRGBO(0, 189, 144, 1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
