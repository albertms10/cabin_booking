import 'package:cabin_booking/model/school_year.dart';
import 'package:cabin_booking/widgets/layout/date_form_field.dart';
import 'package:cabin_booking/widgets/layout/item_info.dart';
import 'package:cabin_booking/widgets/layout/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class SchoolYearForm extends StatefulWidget {
  final SchoolYear schoolYear;

  const SchoolYearForm({required this.schoolYear});

  @override
  _SchoolYearFormState createState() => _SchoolYearFormState();
}

class _SchoolYearFormState extends State<SchoolYearForm> {
  final _formKey = GlobalKey<FormState>();

  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  late final SchoolYear _schoolYear = widget.schoolYear;

  @override
  void initState() {
    super.initState();

    if (widget.schoolYear.startDate != null) {
      _startDateController.text =
          DateFormat.yMd().format(widget.schoolYear.startDate!);
    }

    if (widget.schoolYear.endDate != null) {
      _endDateController.text =
          DateFormat.yMd().format(widget.schoolYear.endDate!);
    }
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Center(
            child: Text(
              '$_schoolYear',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          const SizedBox(height: 32.0),
          Row(
            children: [
              Expanded(
                child: DateFormField(
                  controller: _startDateController,
                  initialDate: _schoolYear.startDate,
                  labelText: appLocalizations.startDate,
                  autofocus: true,
                  additionalValidator: (date) {
                    if (_schoolYear.endDate != null &&
                        date.isAfter(_schoolYear.endDate!)) {
                      return appLocalizations.enterDate;
                    }

                    return null;
                  },
                  onChanged: (date) {
                    setState(() => _schoolYear.startDate = date);
                  },
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: DateFormField(
                  controller: _endDateController,
                  initialDate: _schoolYear.endDate,
                  labelText: appLocalizations.endDate,
                  additionalValidator: (date) {
                    if (_schoolYear.startDate != null &&
                        date.isBefore(_schoolYear.startDate!)) {
                      return appLocalizations.enterDate;
                    }

                    return null;
                  },
                  onChanged: (date) {
                    setState(() => _schoolYear.endDate = date);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          SubmitButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                Navigator.of(context).pop<SchoolYear>(_schoolYear);
              }
            },
            shouldAdd: widget.schoolYear.startDate == null,
          ),
          const SizedBox(height: 16.0),
          ItemInfo(
            creationDateTime: _schoolYear.creationDateTime,
            modificationDateTime: _schoolYear.modificationDateTime,
            modificationCount: _schoolYear.modificationCount,
          ),
        ],
      ),
    );
  }
}
