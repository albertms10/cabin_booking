import 'package:flutter/material.dart';

class HorizontalIndicator extends StatelessWidget {
  final double? verticalOffset;
  final Widget? label;
  final Color? indicatorColor;

  const HorizontalIndicator({
    super.key,
    this.verticalOffset,
    this.label,
    this.indicatorColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: verticalOffset,
          child: Container(
            alignment: AlignmentDirectional.bottomStart,
            padding: const EdgeInsets.all(8),
            child: label,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: indicatorColor,
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(3, 4),
                blurRadius: 3,
              ),
            ],
          ),
          width: double.infinity,
          height: 2,
        ),
      ],
    );
  }
}
