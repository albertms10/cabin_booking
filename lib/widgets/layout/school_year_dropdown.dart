import 'package:cabin_booking/model/day_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SchoolYearDropdown extends StatefulWidget {
  const SchoolYearDropdown();

  @override
  _SchoolYearDropdownState createState() => _SchoolYearDropdownState();
}

class _SchoolYearDropdownState extends State<SchoolYearDropdown> {
  DayHandler _dayHandler;
  int _currentIndex;

  @override
  void initState() {
    super.initState();

    _dayHandler = Provider.of<DayHandler>(context, listen: false);

    _currentIndex = _dayHandler.schoolYearManager.schoolYearIndex;

    _dayHandler.addListener(() {
      setState(() {
        _currentIndex = _dayHandler.schoolYearManager.schoolYearIndex;
      });
    });
  }

  @override
  void dispose() {
    _dayHandler.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final schoolYearManager =
        Provider.of<DayHandler>(context).schoolYearManager;

    return DropdownButton<int>(
      value: _currentIndex,
      onChanged: (index) {
        setState(() {
          _currentIndex = index;
          schoolYearManager.schoolYearIndex = index;
        });
      },
      underline: const SizedBox(),
      items: [
        for (var i = 0; i < schoolYearManager.schoolYears.length; i++)
          DropdownMenuItem<int>(
            child: Text('${schoolYearManager.schoolYears[i]}'),
            value: i,
          )
      ],
    );
  }
}
