import 'package:cabin_booking/model/cabin.dart';
import 'package:flutter/material.dart';

class CabinsRow extends StatelessWidget {
  final List<Cabin> cabins;

  CabinsRow({this.cabins = const []});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 32),
      child: Material(
        elevation: 2,
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Container(),
              ),
              for (int cabin = 0; cabin < cabins.length; cabin++)
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue[400],
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${cabins[cabin].number}',
                      style: Theme.of(context).accentTextTheme.headline5,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
