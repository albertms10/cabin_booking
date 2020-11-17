import 'package:cabin_booking/l10n/app_localizations.dart';
import 'package:cabin_booking/model/booking.dart';
import 'package:cabin_booking/model/cabin.dart';
import 'package:cabin_booking/model/cabin_manager.dart';
import 'package:cabin_booking/utils/time_of_day.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookingForm extends StatefulWidget {
  final Booking booking;

  BookingForm(this.booking);

  @override
  _BookingFormState createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  final _formKey = GlobalKey<FormState>();

  final Booking _booking = Booking();

  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();

  TimeOfDay _startTime;
  TimeOfDay _endTime;

  @override
  void initState() {
    super.initState();

    _startTime = TimeOfDay.fromDateTime(widget.booking.dateStart);
    _endTime = TimeOfDay.fromDateTime(widget.booking.dateEnd);

    _booking.cabinId = widget.booking.cabinId;
  }

  @override
  Widget build(BuildContext context) {
    _startTimeController.text = _startTime.format(context);
    _endTimeController.text = _endTime.format(context);

    final cabinManager = Provider.of<CabinManager>(context);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButton<String>(
            value: _booking.cabinId,
            onChanged: (value) {
              setState(() {
                _booking.cabinId = value;
              });
            },
            items: [
              for (Cabin cabin in cabinManager.cabins)
                DropdownMenuItem(
                  value: cabin.id,
                  child: Text(
                    '${AppLocalizations.of(context).cabin} ${cabin.number}',
                  ),
                ),
            ],
            isExpanded: true,
          ),
          const SizedBox(height: 24),
          TextFormField(
            initialValue: widget.booking.studentName,
            autofocus: true,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (String value) {
              if (value.isEmpty)
                return AppLocalizations.of(context).enterStudentName;

              return null;
            },
            onSaved: (value) {
              _booking.studentName = value;
            },
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context).student,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 10,
                child: TextFormField(
                  controller: _startTimeController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    final _parsedDateTime =
                        tryParseDateTimeWithFormattedTimeOfDay(
                      dateTime: widget.booking.dateStart,
                      formattedTimeOfDay: value,
                    );

                    if (value.isEmpty || _parsedDateTime == null)
                      return AppLocalizations.of(context).enterStartTime;

                    if (_parsedDateTime.compareTo(
                          tryParseDateTimeWithFormattedTimeOfDay(
                            dateTime: widget.booking.dateStart,
                            formattedTimeOfDay: _endTime.format(context),
                          ),
                        ) >
                        0) return AppLocalizations.of(context).enterValidRange;

                    return null;
                  },
                  onTap: () async {
                    final _time = await showTimePicker(
                      context: context,
                      initialTime: _startTime,
                    );

                    if (_time != null)
                      setState(() {
                        _startTime = _time;
                        _startTimeController.text = _time.format(context);
                      });
                  },
                  onSaved: (value) {
                    _booking.dateStart = tryParseDateTimeWithFormattedTimeOfDay(
                      dateTime: widget.booking.dateStart,
                      formattedTimeOfDay: value,
                    );
                  },
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).start,
                    border: const OutlineInputBorder(),
                    icon: const Icon(Icons.schedule),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 7,
                child: TextFormField(
                  controller: _endTimeController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    final _parsedDateTime =
                        tryParseDateTimeWithFormattedTimeOfDay(
                      dateTime: widget.booking.dateStart,
                      formattedTimeOfDay: value,
                    );

                    if (value.isEmpty || _parsedDateTime == null)
                      return AppLocalizations.of(context).enterEndTime;

                    if (_parsedDateTime.compareTo(
                          tryParseDateTimeWithFormattedTimeOfDay(
                            dateTime: widget.booking.dateStart,
                            formattedTimeOfDay: _startTime.format(context),
                          ),
                        ) <
                        0) return AppLocalizations.of(context).enterValidRange;

                    return null;
                  },
                  onTap: () async {
                    final _time = await showTimePicker(
                      context: context,
                      initialTime: _endTime,
                    );

                    if (_time != null)
                      setState(() {
                        _endTime = _time;
                        _endTimeController.text = _time.format(context);
                      });
                  },
                  onSaved: (value) {
                    _booking.dateEnd = tryParseDateTimeWithFormattedTimeOfDay(
                      dateTime: widget.booking.dateEnd,
                      formattedTimeOfDay: value,
                    );
                  },
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).end,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();

                  if (widget.booking.id != null)
                    _booking.id = widget.booking.id;

                  Navigator.of(context).pop<Booking>(_booking);
                }
              },
              icon: widget.booking.studentName == null
                  ? const Icon(Icons.add)
                  : const Icon(Icons.check),
              label: Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  widget.booking.studentName == null
                      ? AppLocalizations.of(context).book.toUpperCase()
                      : MaterialLocalizations.of(context)
                          .saveButtonLabel
                          .toUpperCase(),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
