import 'package:DigiBus/ui/bottom_navs/history.dart';
import 'package:DigiBus/ui/bottom_navs/home/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A stateful widget class to display the home page
class Index extends StatefulWidget {
  static const String id = 'index_page';

  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  /// Current index of the bottom navigation
  int currentIndex = 0;

  ///To navigate back home from child pages
  void returnHome() {
    setState(() {
      currentIndex = 0;
    });
  }

  ///Navigate to [SendMoney] page from child pages
  void navToSendMoney() {
    setState(() {
      currentIndex = 2;
    });
  }

  /// Navigating classes for the bottom navigation
  final List<Widget> _children = [
    Home(),
    History(),
  ];

  @override
  void initState() {
    super.initState();
    // _children[0] = Home(
    //   navToHome: navToSendMoney,
    // );
    // _children[2] = SendMoney(
    //   returnHome: returnHome,
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFFFFFFF),
      body: _children[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xff1dbc92),
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        selectedLabelStyle: TextStyle(
          fontFamily: 'Regular',
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Regular',
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        selectedItemColor: Color(0xFFFFFFFF),
        unselectedItemColor: Color(0xFFCCCCCC),
        onTap: _onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 25,
              color: Color(0xFFCCCCCC),
            ),
            activeIcon: Icon(
              Icons.home,
              size: 25,
              color: Color(0xFFFFFFFF),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.timer,
              size: 25,
              color: Color(0xFFCCCCCC),
            ),
            activeIcon: Icon(
              Icons.timer,
              size: 25,
              color: Color(0xFFFFFFFF),
            ),
            label: 'My History',
          ),
        ],
      ),
    );
  }

  /// Navigating to other bottom tabs
  void _onTabTapped(int index) {
    if (!mounted) return;
    setState(() {
      currentIndex = index;
    });
  }
}
