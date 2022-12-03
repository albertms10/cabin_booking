import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class JumpBarField extends StatelessWidget {
  final TextEditingController? controller;

  const JumpBarField({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    return TextFormField(
      controller: controller,
      autofocus: true,
      decoration: InputDecoration(
        hintText: appLocalizations.typeANewBooking,
        filled: false,
        border: InputBorder.none,
        icon: const Padding(
          padding: EdgeInsetsDirectional.only(start: 12),
          child: Icon(Icons.search),
        ),
        contentPadding: const EdgeInsetsDirectional.only(end: 16),
      ),
    );
  }
}
