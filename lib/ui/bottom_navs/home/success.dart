import 'package:DigiBus/ui/index.dart';
import 'package:DigiBus/ui/ticket.dart';
import 'package:DigiBus/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Success extends StatefulWidget {
  static const String id = 'success_page';

  Success({
    this.date,
    this.amount,
    this.destination,
    this.origin,
  });

  final date;
  final amount;
  final origin;
  final destination;

  @override
  _SuccessState createState() => _SuccessState();
}

class _SuccessState extends State<Success> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(15, 50, 15, 0),
        width: SizeConfig.screenWidth,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Booking Successful! 🥳',
                style: TextStyle(
                  fontFamily: 'Regular',
                  fontSize: 20,
                  color: Color(0xff1dbc92),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xff1dbc92),
                ),
                child: Center(
                  child: Icon(
                    Icons.check,
                    size: 45,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Ticket(
                date: widget.date,
                price: widget.amount,
                origin: widget.origin,
                destination: widget.destination,
              ),
              SizedBox(
                height: 35,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil<dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) => Index(),
                    ),
                    (route) => false,
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
                        'Go Home',
                        style: TextStyle(
                          fontFamily: 'Regular',
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        Icons.home,
                        size: 20,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 55,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
