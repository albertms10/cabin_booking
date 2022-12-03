import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CabinIcon extends StatelessWidget {
  final int number;
  final double radius;

  const CabinIcon({super.key, required this.number, this.radius = 28});

  const factory CabinIcon.progress({
    Key? key,
    required int number,
    double radius,
    required double progress,
  }) = _ProgressCabinIcon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CircleAvatar(
      backgroundColor: theme.colorScheme.secondary,
      radius: radius,
      child: _CabinIconText(
        number: number,
        color: theme.colorScheme.onSecondary,
      ),
    );
  }
}

class _ProgressCabinIcon extends CabinIcon {
  final double progress;

  const _ProgressCabinIcon({
    super.key,
    required super.number,
    super.radius = 28,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appLocalizations = AppLocalizations.of(context)!;

    return Tooltip(
      message: appLocalizations.nPercentOccupied((progress * 100).ceil()),
      child: Stack(
        alignment: AlignmentDirectional.center,
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
          _CabinIconText(number: number),
        ],
      ),
    );
  }
}

class _CabinIconText extends StatelessWidget {
  final int number;
  final Color? color;

  const _CabinIconText({super.key, required this.number, this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      '$number',
      style: theme.textTheme.headline5?.copyWith(color: color),
      textAlign: TextAlign.center,
    );
  }
}
