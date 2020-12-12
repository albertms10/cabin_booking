import 'package:cabin_booking/model/cabin.dart';
import 'package:cabin_booking/widgets/cabin/cabin_icon.dart';
import 'package:cabin_booking/widgets/layout/item_info.dart';
import 'package:cabin_booking/widgets/layout/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CabinForm extends StatefulWidget {
  final Cabin cabin;
  final int newCabinNumber;

  const CabinForm({
    this.cabin,
    this.newCabinNumber,
  });

  @override
  _CabinFormState createState() => _CabinFormState();
}

class _CabinFormState extends State<CabinForm> {
  final _formKey = GlobalKey<FormState>();

  Cabin _cabin;

  @override
  void initState() {
    super.initState();

    _cabin = widget.cabin;

    if (widget.newCabinNumber != null) {
      _cabin = widget.cabin..number = widget.newCabinNumber;
    }
  }

  String _validator(value) {
    if (value.isEmpty) {
      return AppLocalizations.of(context).enterValue;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          CabinIcon(number: _cabin.number),
          const SizedBox(height: 32.0),
          ListTile(
            title: Text(appLocalizations.lecterns),
            trailing: SizedBox(
              width: 80.0,
              child: TextFormField(
                initialValue: '${_cabin.components.lecterns}',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: _validator,
                onSaved: (lecterns) {
                  _cabin.components.lecterns = int.tryParse(lecterns);
                },
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          ListTile(
            title: Text(appLocalizations.chairs),
            trailing: SizedBox(
              width: 80.0,
              child: TextFormField(
                initialValue: '${_cabin.components.chairs}',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: _validator,
                onSaved: (chairs) {
                  _cabin.components.chairs = int.tryParse(chairs);
                },
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          ListTile(
            title: Text(appLocalizations.tables),
            trailing: SizedBox(
              width: 80.0,
              child: TextFormField(
                initialValue: '${_cabin.components.tables}',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: _validator,
                onSaved: (tables) {
                  _cabin.components.tables = int.tryParse(tables);
                },
              ),
            ),
          ),
          const SizedBox(height: 32.0),
          SubmitButton(
            shouldAdd: widget.newCabinNumber != null,
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();

                Navigator.of(context).pop<Cabin>(_cabin);
              }
            },
          ),
          if (widget.newCabinNumber == null)
            ItemInfo(
              creationDate: widget.cabin.creationDate,
              modificationDate: widget.cabin.modificationDate,
              modificationCount: widget.cabin.modificationCount,
            ),
        ],
      ),
    );
  }
}
