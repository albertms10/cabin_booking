import 'package:cabin_booking/model/cabin.dart';
import 'package:cabin_booking/model/cabin_manager.dart';
import 'package:cabin_booking/widgets/cabin/cabin_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CabinsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2.0,
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Consumer<CabinManager>(
          builder: (context, cabinManager, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                child,
                for (Cabin cabin in cabinManager.cabins)
                  Expanded(
                    child: CabinIcon(number: cabin.number),
                  ),
              ],
            );
          },
          child: Container(width: 180.0),
        ),
      ),
    );
  }
}
