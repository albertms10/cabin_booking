import 'package:cabin_booking/model.dart';
import 'package:cabin_booking/widgets/layout/date_form_field.dart';
import 'package:cabin_booking/widgets/layout/item_info.dart';
import 'package:cabin_booking/widgets/layout/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class SchoolYearForm extends StatefulWidget {
  final SchoolYear schoolYear;

  const SchoolYearForm({super.key, required this.schoolYear});

  @override
  State<SchoolYearForm> createState() => _SchoolYearFormState();
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
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: DateFormField(
                  controller: _startDateController,
                  labelText: appLocalizations.startDate,
                  autofocus: true,
                  initialDate: _schoolYear.startDate,
                  onChanged: (date) {
                    setState(() => _schoolYear.startDate = date);
                  },
                  additionalValidator: (date) {
                    if (_schoolYear.endDate != null &&
                        date.isAfter(_schoolYear.endDate!)) {
                      return appLocalizations.enterDate;
                    }

                    return null;
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DateFormField(
                  controller: _endDateController,
                  labelText: appLocalizations.endDate,
                  initialDate: _schoolYear.endDate,
                  onChanged: (date) {
                    setState(() => _schoolYear.endDate = date);
                  },
                  additionalValidator: (date) {
                    if (_schoolYear.startDate != null &&
                        date.isBefore(_schoolYear.startDate!)) {
                      return appLocalizations.enterDate;
                    }

                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SubmitButton(
            shouldAdd: widget.schoolYear.startDate == null,
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                Navigator.of(context).pop<SchoolYear>(_schoolYear);
              }
            },
          ),
          const SizedBox(height: 16),
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
