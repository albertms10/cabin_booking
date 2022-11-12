import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CabinIcon extends StatelessWidget {
  final int number;
  final double? progress;

  const CabinIcon({
    super.key,
    required this.number,
    this.progress,
  });

  double get radius => 28;

  bool get shouldShowProgress => progress != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final text = Text(
      '$number',
      style: theme.textTheme.headline5?.copyWith(
        color: shouldShowProgress
            ? theme.colorScheme.secondary
            : theme.colorScheme.onSecondary,
      ),
      textAlign: TextAlign.center,
    );

    // TODO(albertms10): split Widgets in different constructors:
    //  CabinIcon(), CabinIcon.progress().
    if (!shouldShowProgress) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: theme.colorScheme.secondary,
        child: text,
      );
    }

    final appLocalizations = AppLocalizations.of(context)!;

    return Tooltip(
      message: appLocalizations.nPercentOccupied((progress! * 100).ceil()),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: radius * 2,
            height: radius * 2,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: progress),
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return CircularProgressIndicator(
                  value: value,
                  backgroundColor:
                      theme.colorScheme.secondary.withOpacity(0.25),
                );
              },
            ),
          ),
          text,
        ],
      ),
    );
  }
}
