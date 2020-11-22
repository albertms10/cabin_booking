import 'package:cabin_booking/widgets/cabin/cabins_table.dart';
import 'package:flutter/material.dart';

class CabinsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 128, vertical: 16),
      child: CabinsTable(),
    );
  }
}
