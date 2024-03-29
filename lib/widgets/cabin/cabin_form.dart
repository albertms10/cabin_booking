import 'package:cabin_booking/model.dart';
import 'package:cabin_booking/widgets/cabin/cabin_icon.dart';
import 'package:cabin_booking/widgets/layout/item_info.dart';
import 'package:cabin_booking/widgets/layout/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CabinForm extends StatefulWidget {
  final Cabin cabin;
  final int? newCabinNumber;

  const CabinForm({
    super.key,
    required this.cabin,
    this.newCabinNumber,
  });

  @override
  State<CabinForm> createState() => _CabinFormState();
}

class _CabinFormState extends State<CabinForm> {
  final _formKey = GlobalKey<FormState>();

  late final Cabin _cabin = widget.cabin;

  @override
  void initState() {
    super.initState();

    if (widget.newCabinNumber != null) {
      _cabin.number = widget.newCabinNumber!;
    }
  }

  String? _validator(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.enterValue;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          CabinIcon(number: _cabin.number),
          const SizedBox(height: 32),
          ListTile(
            title: Text(appLocalizations.lecterns),
            trailing: SizedBox(
              width: 80,
              child: TextFormField(
                initialValue: '${_cabin.elements.lecterns}',
                keyboardType: TextInputType.number,
                onSaved: (lecterns) {
                  _cabin.elements.lecterns = int.tryParse(lecterns ?? '') ?? 0;
                },
                validator: _validator,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            title: Text(appLocalizations.chairs),
            trailing: SizedBox(
              width: 80,
              child: TextFormField(
                initialValue: '${_cabin.elements.chairs}',
                keyboardType: TextInputType.number,
                onSaved: (chairs) {
                  _cabin.elements.chairs = int.tryParse(chairs ?? '') ?? 0;
                },
                validator: _validator,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            title: Text(appLocalizations.tables),
            trailing: SizedBox(
              width: 80,
              child: TextFormField(
                initialValue: '${_cabin.elements.tables}',
                keyboardType: TextInputType.number,
                onSaved: (tables) {
                  _cabin.elements.tables = int.tryParse(tables ?? '') ?? 0;
                },
                validator: _validator,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
          ),
          const SizedBox(height: 32),
          SubmitButton(
            shouldAdd: widget.newCabinNumber != null,
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                Navigator.of(context).pop<Cabin>(_cabin);
              }
            },
          ),
          if (widget.newCabinNumber == null)
            Padding(
              padding: const EdgeInsetsDirectional.only(top: 16),
              child: ItemInfo(
                creationDateTime: widget.cabin.creationDateTime,
                modificationDateTime: widget.cabin.modificationDateTime,
                modificationCount: widget.cabin.modificationCount,
              ),
            ),
        ],
      ),
    );
  }
}
