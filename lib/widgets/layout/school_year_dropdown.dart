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

  void _setSchoolYearState() {
    setState(() {
      _currentIndex = _dayHandler.schoolYearManager.schoolYearIndex;
    });
  }

  @override
  void initState() {
    super.initState();

    _dayHandler = Provider.of<DayHandler>(context, listen: false);

    _currentIndex = _dayHandler.schoolYearManager.schoolYearIndex;

    _dayHandler.addListener(_setSchoolYearState);
  }

  @override
  void dispose() {
    _dayHandler.removeListener(_setSchoolYearState);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dayHandler = Provider.of<DayHandler>(context);

    return DropdownButton<int>(
      value: _currentIndex,
      onChanged: (index) {
        setState(() {
          _currentIndex = index;
          dayHandler.schoolYearIndex = index;
        });
      },
      underline: const SizedBox(),
      items: [
        for (var i = 0; i < dayHandler.schoolYears.length; i++)
          DropdownMenuItem<int>(
            child: Text('${dayHandler.schoolYears[i]}'),
            value: i,
          )
      ],
    );
  }
}
