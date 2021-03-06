import 'package:flutter/material.dart';

class HorizontalIndicator extends StatelessWidget {
  final double? verticalOffset;
  final Widget? label;
  final Color? indicatorColor;

  const HorizontalIndicator({
    Key? key,
    this.verticalOffset,
    this.label,
    this.indicatorColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: verticalOffset,
          child: Container(
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.all(8.0),
            child: label,
          ),
        ),
        Container(
          width: double.infinity,
          height: 2.0,
          decoration: BoxDecoration(
            color: indicatorColor,
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 3.0,
                offset: Offset(3.0, 4.0),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
