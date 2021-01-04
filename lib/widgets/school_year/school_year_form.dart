import 'package:cabin_booking/model/school_year.dart';
import 'package:cabin_booking/widgets/layout/item_info.dart';
import 'package:cabin_booking/widgets/layout/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class SchoolYearForm extends StatefulWidget {
  final SchoolYear schoolYear;

  const SchoolYearForm({this.schoolYear});

  @override
  _SchoolYearFormState createState() => _SchoolYearFormState();
}

class _SchoolYearFormState extends State<SchoolYearForm> {
  final _formKey = GlobalKey<FormState>();

  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  SchoolYear _schoolYear;

  @override
  void initState() {
    super.initState();

    if (widget.schoolYear.startDate != null) {
      _startDateController.text =
          DateFormat.yMd().format(widget.schoolYear.startDate);
    }

    if (widget.schoolYear.endDate != null) {
      _endDateController.text =
          DateFormat.yMd().format(widget.schoolYear.endDate);
    }

    _schoolYear = widget.schoolYear;
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);

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
                  onChange: (date) {
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
                  onChange: (date) {
                    setState(() => _schoolYear.endDate = date);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          SubmitButton(
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();

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

class DateFormField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final bool autofocus;

  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  final void Function(DateTime) onChange;

  DateFormField({
    Key key,
    this.controller,
    this.labelText,
    this.autofocus = false,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.onChange,
  }) : super(key: key);

  @override
  _DateFormFieldState createState() => _DateFormFieldState();
}

class _DateFormFieldState extends State<DateFormField> {
  DateTime _date;
  DateTime _firstDate;
  DateTime _lastDate;

  @override
  void initState() {
    super.initState();

    _date = widget.initialDate;
    _firstDate = widget.firstDate ??
        DateTime.now().subtract(const Duration(days: 365 * 20));
    _lastDate =
        widget.lastDate ?? DateTime.now().add(const Duration(days: 365 * 20));
  }

  DateTime _tryParseDate(String value) {
    try {
      return DateFormat.yMd().parseLoose(value);
    } on FormatException {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      autofocus: widget.autofocus,
      decoration: InputDecoration(labelText: widget.labelText),
      onChanged: (value) {
        final date = _tryParseDate(value);

        if (date != null &&
            date.isAfter(_firstDate) &&
            date.isBefore(_lastDate)) {
          setState(() {
            _date = date;
            widget.onChange?.call(date);
          });
        }
      },
      onTap: () async {
        if (_date != null &&
            (_date.isBefore(_firstDate) || _date.isAfter(_lastDate))) return;

        final date = await showDatePicker(
          context: context,
          initialDate: _date ?? DateTime.now(),
          firstDate: _firstDate,
          lastDate: _lastDate,
        );

        if (date != null) {
          setState(() {
            _date = date;
            widget.controller.text = DateFormat.yMd().format(date);
            widget.onChange?.call(date);
          });
        }
      },
      validator: (value) {
        if (value.isEmpty) {
          return AppLocalizations.of(context).enterDate;
        }

        final date = _tryParseDate(value);

        if (date == null) {
          return AppLocalizations.of(context).enterDate;
        }

        if (date.isBefore(_firstDate) || date.isAfter(_lastDate)) {
          return AppLocalizations.of(context).enterDate;
        }

        return null;
      },
    );
  }
}
