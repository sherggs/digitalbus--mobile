import 'dart:async';

import 'package:DigiBus/ui/onboard-users/signin.dart';
import 'package:DigiBus/ui/onboard-users/signup.dart';
import 'package:DigiBus/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Welcome extends StatefulWidget {
  static const String id = 'welcome_page';

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  PageController pageController = new PageController();
  int index = 0;
  Timer timer;

  void initState() {
    super.initState();
    timer = Timer.periodic(
      Duration(milliseconds: 4500),
      (timer) => carousel(),
    );
  }

  onImageChange(int page) {
    index = page;
    setState(() {
      if (page == 0) {
        indicator = Center(
          child: Container(
            width: 53,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 28,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(0, 189, 144, 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 10,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(0, 189, 144, 0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                ClipRRect(
                  child: Container(
                    width: 10,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(0, 189, 144, 0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      } else if (page == 1) {
        indicator = Center(
          child: Container(
            width: 53,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                      width: 10,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(0, 189, 144, 0.5),
                        borderRadius: BorderRadius.circular(10),
                      )),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 28,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(0, 189, 144, 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 10,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(0, 189, 144, 0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      } else if (page == 2) {
        indicator = Center(
          child: Container(
            width: 53,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ClipRRect(
                  child: Container(
                    width: 10,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(0, 189, 144, 0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                ClipRRect(
                  child: Container(
                    width: 10,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(0, 189, 144, 0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 28,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(0, 189, 144, 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    });
  }

  carousel() {
    if (index == 2) {
      index = 0;
      pageController.animateToPage(
        0,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeIn,
      );
    } else {
      index += 1;
      pageController.nextPage(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    }
  }

  Widget indicator = Center(
    child: Container(
      width: 53,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 28,
              height: 5,
              decoration: BoxDecoration(
                color: Color.fromRGBO(0, 189, 144, 1),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 10,
              height: 5,
              decoration: BoxDecoration(
                color: Color.fromRGBO(0, 189, 144, 0.5),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 10,
              height: 5,
              decoration: BoxDecoration(
                color: Color.fromRGBO(0, 189, 144, 0.5),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: SizeConfig.screenWidth,
                  height: SizeConfig.screenHeight * 0.6,
                  child: PageView(
                    controller: pageController,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(21, 5, 0, 10),
                            child: Text(
                              "We've got plans that covers everyone.",
                              style: TextStyle(
                                fontSize: 24,
                                fontFamily: 'Circular',
                                color: Color.fromRGBO(0, 189, 144, 1),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Image.asset(
                                'assets/images/family.png',
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(21, 5, 0, 10),
                            child: Text(
                              "We've got one of the best transport rate.",
                              style: TextStyle(
                                fontSize: 24,
                                fontFamily: 'Circular',
                                color: Color.fromRGBO(0, 189, 144, 1),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Image.asset(
                                'assets/images/credit-card.png',
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(21, 5, 0, 10),
                            child: Text(
                              "Pack your bags and get ready for a great time.",
                              style: TextStyle(
                                fontSize: 24,
                                fontFamily: 'Circular',
                                color: Color.fromRGBO(0, 189, 144, 1),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Image.asset(
                                'assets/images/pack.png',
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    onPageChanged: onImageChange,
                  ),
                ),
                indicator,
                SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 26),
                  child: Center(
                    child: RaisedButton(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: 60,
                        child: Center(
                          child: Text(
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
                        timer.cancel();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignIn(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                    child: GestureDetector(
                      onTap: () {
                        timer.cancel();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUp(),
                          ),
                        );
                      },
                      child: Text(
                        "SIGN UP",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Circular',
                          color: Color.fromRGBO(0, 189, 144, 1),
                        ),
                      ),
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
