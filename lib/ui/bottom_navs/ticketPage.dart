import 'package:DigiBus/ui/ticket.dart';
import 'package:DigiBus/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TicketPage extends StatefulWidget {
  static const String id = 'ticket_page_page';

  TicketPage({
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
  _TicketPageState createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xff1dbc92),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 18,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          'Ticket',
          style: TextStyle(
            fontFamily: 'Regular',
            fontSize: 20,
            color: Color(0xff000000),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(15, 50, 15, 0),
        width: SizeConfig.screenWidth,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
            ],
          ),
        ),
      ),
    );
  }
}
