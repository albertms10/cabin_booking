import 'package:cabin_booking/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingForm extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;

  BookingForm({
    @required this.startDate,
    @required this.endDate,
  });

  @override
  _BookingFormState createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context).student,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: DateFormat.Hm().format(widget.startDate),
            onTap: () {
              showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(widget.startDate),
              );
            },
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context).start,
              border: const OutlineInputBorder(),
              icon: Icon(Icons.schedule),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: DateFormat.Hm().format(widget.endDate),
            onTap: () {
              showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(widget.endDate),
              );
            },
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context).end,
              border: const OutlineInputBorder(),
              icon: Icon(Icons.schedule),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.add),
            label: Text(AppLocalizations.of(context).book.toUpperCase()),
          )
        ],
      ),
    );
  }
}
