import 'package:flutter/material.dart';

class CabinIcon extends StatelessWidget {
  final int number;
  final double progress;

  CabinIcon({@required this.number, this.progress});

  @override
  Widget build(BuildContext context) {
    final size = 52.0;
    final showProgress = progress != null;

    final text = Text(
      '$number',
      style: Theme.of(context).accentTextTheme.headline5.copyWith(
            color: showProgress ? Colors.blue : null,
          ),
      textAlign: TextAlign.center,
    );

    return showProgress
        ? Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: size,
                height: size,
                child: CircularProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.blue[50],
                ),
              ),
              text,
            ],
          )
        : Container(
            width: size,
            height: size,
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.blue[400],
              shape: BoxShape.circle,
            ),
            child: text,
          );
  }
}
