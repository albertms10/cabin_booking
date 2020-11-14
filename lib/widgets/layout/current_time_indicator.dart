import 'package:cabin_booking/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CurrentTimeIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int _difference = DateTime.now()
        .difference(DateTime.parse(
            DateFormat('yyyy-MM-dd').format(DateTime.now()) + ' 15:00'))
        .inMinutes;

    return _difference > 0
        ? Column(
            children: [
              SizedBox(
                height: _difference * bookingHeightRatio,
                child: Container(
                  alignment: Alignment.bottomLeft,
                  padding: EdgeInsets.all(8),
                  child: Text(
                    DateFormat('HH:mm').format(DateTime.now()),
                    style: TextStyle(
                      color: Colors.red[400],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                height: 3,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.red[400],
                  boxShadow: [
                    const BoxShadow(
                      color: Colors.black12,
                      blurRadius: 3,
                      offset: Offset(3, 4),
                    ),
                  ],
                ),
              ),
            ],
          )
        : Container();
  }
}
