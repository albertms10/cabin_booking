import 'package:cabin_booking/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final bool shouldAdd;
  final Function onPressed;

  SubmitButton({this.shouldAdd = false, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: shouldAdd ? const Icon(Icons.add) : const Icon(Icons.check),
        label: Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            shouldAdd
                ? AppLocalizations.of(context).add.toUpperCase()
                : MaterialLocalizations.of(context)
                    .saveButtonLabel
                    .toUpperCase(),
          ),
        ),
      ),
    );
  }
}
