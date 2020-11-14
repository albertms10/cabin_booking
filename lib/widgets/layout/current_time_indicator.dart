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
              SizedBox(height: _difference * bookingHeightRatio),
              Row(
                children: [
                  Container(
                    height: 14,
                    width: 14,
                    decoration: BoxDecoration(
                      color: Colors.red[400],
                      shape: BoxShape.circle,
                      boxShadow: [
                        const BoxShadow(
                          color: Colors.black12,
                          blurRadius: 3,
                          offset: Offset(3, 4),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 4,
                    width: MediaQuery.of(context).size.width - 14,
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
              ),
            ],
          )
        : Container();
  }
}
