import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SubmitButton extends StatelessWidget {
  final bool shouldAdd;
  final void Function()? onPressed;

  const SubmitButton({Key? key, this.shouldAdd = false, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: shouldAdd ? const Icon(Icons.add) : const Icon(Icons.check),
        label: Container(
          margin: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text(
            shouldAdd
                ? AppLocalizations.of(context)!.add.toUpperCase()
                : MaterialLocalizations.of(context)
                    .saveButtonLabel
                    .toUpperCase(),
          ),
        ),
      ),
    );
  }
}
