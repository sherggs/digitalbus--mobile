import 'package:DigiBus/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Separator extends StatelessWidget {
  final double height;
  final Color color;

  const Separator({this.height = 1, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashWidth = 7.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}

class Ticket extends StatelessWidget {
  final String date;
  final String destination;
  final String origin;
  final String price;

  Ticket({
    this.date,
    this.destination,
    this.origin,
    this.price,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Column(
      children: <Widget>[
        Center(
          child: Container(
            padding: EdgeInsets.all(10),
            width: SizeConfig.screenWidth,
            color: Color(0XFFDADADA),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Image.asset(
                  'assets/images/logo.png',
                  width: 55,
                  fit: BoxFit.contain,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'DigiBus',
                  style: TextStyle(
                    fontFamily: 'Regular',
                    fontSize: 16,
                    color: Color(0xff1dbc92),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Transform.translate(
                      offset: Offset(-25, 0),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Separator(
                        color: Colors.grey,
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(25, 0),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                      ),
                    ),
                  ],
                ),
                Center(
                  child: Text(
                    '$date',
                    style: TextStyle(
                      color: Color(0xff000000),
                      fontSize: 20,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Separator(
                                  color: Colors.blueGrey,
                                ),
                              ),
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0.5, 0, 7.5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        '$origin',
                        style: TextStyle(
                          color: Color.fromRGBO(95, 95, 95, 1),
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        '$destination',
                        style: TextStyle(
                          color: Color.fromRGBO(95, 95, 95, 1),
                          fontSize: 20,
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                  child: Text(
                    '₦$price',
                    style: TextStyle(
                      color: Color(0xff1dbc92),
                      fontSize: 27,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(3, 7.5, 3, 7.5),
                  child: Separator(color: Colors.grey),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 15.5, 10, 7.5),
                  child: Text(
                    'Please note there is no return of money after payment.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromRGBO(95, 95, 95, 1),
                      fontSize: 14,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 2.5, 10, 2.5),
                  child: Text(
                    'Ticket is not transferable.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromRGBO(95, 95, 95, 1),
                      fontSize: 14,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 7.5, 10, 15),
                  child: Text(
                    'Ticket valid for one trip only.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromRGBO(95, 95, 95, 1),
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
