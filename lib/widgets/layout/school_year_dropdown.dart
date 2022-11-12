import 'package:cabin_booking/model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SchoolYearDropdown extends StatefulWidget {
  const SchoolYearDropdown({super.key});

  @override
  _SchoolYearDropdownState createState() => _SchoolYearDropdownState();
}

class _SchoolYearDropdownState extends State<SchoolYearDropdown> {
  late final DayHandler _dayHandler =
      Provider.of<DayHandler>(context, listen: false)
        ..addListener(_setSchoolYearState);
  late int? _currentIndex = _dayHandler.schoolYearManager.schoolYearIndex;

  @override
  void dispose() {
    _dayHandler.removeListener(_setSchoolYearState);

    super.dispose();
  }

  void _setSchoolYearState() {
    setState(() {
      _currentIndex = _dayHandler.schoolYearManager.schoolYearIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dayHandler = Provider.of<DayHandler>(context);

    final schoolYears = dayHandler.schoolYearManager.schoolYears;

    return DropdownButton<int>(
      value: _currentIndex,
      onChanged: (index) {
        if (index == null) return;

        setState(() {
          _currentIndex = index;
          dayHandler.schoolYearIndex = index;
        });
      },
      underline: const SizedBox(),
      items: [
        for (var i = 0; i < schoolYears.length; i++)
          DropdownMenuItem<int>(
            value: i,
            child: Text('${schoolYears.elementAt(i)}'),
          ),
      ],
    );
  }
}
