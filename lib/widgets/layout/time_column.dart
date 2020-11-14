import 'package:flutter/material.dart';

class TimeColumn extends StatelessWidget {
  final int start;
  final int end;

  TimeColumn({@required this.start, @required this.end});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int time = start; time <= end; time++)
          Container(
            height: 60 * 1.7,
            padding: EdgeInsets.all(16),
            child: Text('$time:00'),
          ),
      ],
    );
  }
}
