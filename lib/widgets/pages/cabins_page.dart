import 'package:cabin_booking/widgets/cabin/cabins_table.dart';
import 'package:flutter/material.dart';

class CabinsPage extends StatefulWidget {
  const CabinsPage({Key? key}) : super(key: key);

  @override
  _CabinsPageState createState() => _CabinsPageState();
}

class _CabinsPageState extends State<CabinsPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return const CabinsTable();
  }
}
