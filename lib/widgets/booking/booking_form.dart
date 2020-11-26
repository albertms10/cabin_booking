import 'package:cabin_booking/constants.dart';
import 'package:cabin_booking/l10n/app_localizations.dart';
import 'package:cabin_booking/model/booking.dart';
import 'package:cabin_booking/model/cabin.dart';
import 'package:cabin_booking/model/cabin_manager.dart';
import 'package:cabin_booking/utils/date.dart';
import 'package:cabin_booking/widgets/layout/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookingForm extends StatefulWidget {
  final Booking booking;

  BookingForm(this.booking, {Key key}) : super(key: key);

  @override
  _BookingFormState createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  final _formKey = GlobalKey<FormState>();

  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();

  Booking _booking;

  TimeOfDay _startTime;
  TimeOfDay _endTime;

  @override
  void initState() {
    super.initState();

    _startTime = TimeOfDay.fromDateTime(widget.booking.dateStart);
    _endTime = TimeOfDay.fromDateTime(widget.booking.dateEnd);

    _booking = widget.booking;
  }

  @override
  void dispose() {
    _startTimeController.dispose();
    _endTimeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _startTimeController.text = _startTime.format(context);
    _endTimeController.text = _endTime.format(context);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Consumer<CabinManager>(
            builder: (context, cabinManager, child) {
              return DropdownButton<String>(
                value: _booking.cabinId,
                onChanged: (value) {
                  setState(() => _booking.cabinId = value);
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
              );
            },
          ),
          const SizedBox(height: 24.0),
          TextFormField(
            initialValue: widget.booking.studentName,
            autofocus: true,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (String value) {
              if (value.isEmpty) {
                return AppLocalizations.of(context).enterStudentName;
              }

              return null;
            },
            onSaved: (value) {
              _booking.studentName = value;
            },
            decoration: InputDecoration(
              labelText: _booking.isDisabled
                  ? AppLocalizations.of(context).description
                  : AppLocalizations.of(context).student,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 10,
                child: Consumer<CabinManager>(
                  builder: (context, cabinManager, child) {
                    return TextFormField(
                      controller: _startTimeController,
                      autovalidateMode: AutovalidateMode.always,
                      validator: (value) {
                        if (value.isEmpty) {
                          return AppLocalizations.of(context).enterStartTime;
                        }

                        final parsedTimeOfDay = tryParseTimeOfDay(value);

                        _booking.timeStart = parsedTimeOfDay;

                        if (_startTime != parsedTimeOfDay) {
                          _startTime = parsedTimeOfDay;
                        }

                        final parsedDateTime =
                            tryParseDateTimeWithFormattedTimeOfDay(
                          dateTime: widget.booking.date,
                          formattedTimeOfDay: value,
                        );

                        if (parsedDateTime == null) {
                          return AppLocalizations.of(context).enterStartTime;
                        }

                        if (parsedDateTime.isAfter(
                              tryParseDateTimeWithFormattedTimeOfDay(
                                dateTime: widget.booking.date,
                                formattedTimeOfDay: _endTime.format(context),
                              ),
                            ) ||
                            parsedDateTime.isBefore(
                              tryParseDateTimeWithFormattedTimeOfDay(
                                dateTime: widget.booking.date,
                                formattedTimeOfDay:
                                    timeTableStartTime.format(context),
                              ),
                            )) {
                          return AppLocalizations.of(context).enterValidRange;
                        }

                        if (cabinManager
                            .getFromId(_booking.cabinId)
                            .bookingsCollideWith(_booking)) {
                          return AppLocalizations.of(context).occupied;
                        }

                        return null;
                      },
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: _startTime,
                        );

                        if (time != null) {
                          setState(() {
                            _startTime = time;
                            _startTimeController.text = time.format(context);
                          });
                        }
                      },
                      onSaved: (value) {
                        _booking.timeStart = tryParseTimeOfDay(value);
                      },
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context).start,
                        border: const OutlineInputBorder(),
                        icon: const Icon(Icons.schedule),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                flex: 8,
                child: Consumer<CabinManager>(
                  builder: (context, cabinManager, child) {
                    return TextFormField(
                      controller: _endTimeController,
                      autovalidateMode: AutovalidateMode.always,
                      validator: (value) {
                        if (value.isEmpty) {
                          return AppLocalizations.of(context).enterEndTime;
                        }

                        final parsedTimeOfDay = tryParseTimeOfDay(value);

                        _booking.timeEnd = parsedTimeOfDay;

                        if (_endTime != parsedTimeOfDay) {
                          _endTime = parsedTimeOfDay;
                        }

                        final parsedDateTime =
                            tryParseDateTimeWithFormattedTimeOfDay(
                          dateTime: widget.booking.date,
                          formattedTimeOfDay: value,
                        );

                        if (parsedDateTime == null) {
                          return AppLocalizations.of(context).enterEndTime;
                        }

                        if (parsedDateTime.isBefore(
                              tryParseDateTimeWithFormattedTimeOfDay(
                                dateTime: widget.booking.date,
                                formattedTimeOfDay: _startTime.format(context),
                              ),
                            ) ||
                            parsedDateTime.isAfter(
                              tryParseDateTimeWithFormattedTimeOfDay(
                                dateTime: widget.booking.date,
                                formattedTimeOfDay:
                                    timeTableEndTime.format(context),
                              ),
                            )) {
                          return AppLocalizations.of(context).enterValidRange;
                        }

                        if (cabinManager
                            .getFromId(_booking.cabinId)
                            .bookingsCollideWith(_booking)) {
                          return AppLocalizations.of(context).occupied;
                        }

                        return null;
                      },
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: _endTime,
                        );

                        if (time != null) {
                          setState(() {
                            _endTime = time;
                            _endTimeController.text = time.format(context);
                          });
                        }
                      },
                      onSaved: (value) {
                        _booking.timeEnd = tryParseTimeOfDay(value);
                      },
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context).end,
                        border: const OutlineInputBorder(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 32.0),
          SubmitButton(
            shouldAdd: widget.booking.studentName == null,
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();

                Navigator.of(context).pop<Booking>(_booking);
              }
            },
          ),
        ],
      ),
    );
  }
}
