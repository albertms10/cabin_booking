import 'package:cabin_booking/model/school_year_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SchoolYearDropdown extends StatefulWidget {
  const SchoolYearDropdown();

  @override
  _SchoolYearDropdownState createState() => _SchoolYearDropdownState();
}

class _SchoolYearDropdownState extends State<SchoolYearDropdown> {
  int _currentIndex;

  @override
  void initState() {
    super.initState();

    _currentIndex =
        Provider.of<SchoolYearManager>(context, listen: false).schoolYearIndex;
  }

  @override
  Widget build(BuildContext context) {
    final schoolYearManager = Provider.of<SchoolYearManager>(context);

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
