import 'package:cabin_booking/constants.dart';
import 'package:cabin_booking/model/day_handler.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timer_builder/timer_builder.dart';

class CurrentTimeIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TimerBuilder.periodic(
      Duration(seconds: 5),
      builder: (context) {
        int _difference = DateTime.now()
            .difference(DateTime.parse(DateFormat('yyyy-MM-dd')
                    .format(Provider.of<DayHandler>(context).dateTime) +
                ' ${timeTableStartTime.format(context)}'))
            .inMinutes;

        return _difference > 0
            ? Column(
                children: [
                  SizedBox(
                    height: _difference * bookingHeightRatio,
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        TimeOfDay.fromDateTime(DateTime.now()).format(context),
                        style: TextStyle(
                          color: Colors.red[400],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 2,
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
      },
    );
  }
}
