import 'package:cabin_booking/widgets/school_year/school_years_table.dart';
import 'package:flutter/material.dart';

class SchoolYearsPage extends StatefulWidget {
  const SchoolYearsPage({super.key});

  @override
  _SchoolYearsPageState createState() => _SchoolYearsPageState();
}

class _SchoolYearsPageState extends State<SchoolYearsPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return const SchoolYearsTable();
  }
}
