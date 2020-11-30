import 'dart:io';

import 'package:cabin_booking/constants.dart';
import 'package:cabin_booking/widgets/booking/periodicity_dropdown.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cabin_booking/model/booking.dart';
import 'package:cabin_booking/model/cabin_manager.dart';
import 'package:cabin_booking/model/recurring_booking.dart';
import 'package:cabin_booking/utils/date.dart';
import 'package:cabin_booking/widgets/cabin/cabin_dropdown.dart';
import 'package:cabin_booking/widgets/layout/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BookingForm extends StatefulWidget {
  final Booking booking;
  final bool isRecurring;
  final Function(bool) setIsRecurring;

  BookingForm(
    this.booking, {
    Key key,
    this.isRecurring,
    this.setIsRecurring,
  }) : super(key: key);

  @override
  _BookingFormState createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  final _formKey = GlobalKey<FormState>();

  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  final _untilController = TextEditingController();
  final _timesController = TextEditingController();

  Booking _booking;
  RecurringBookingMethod _recurringBookingMethod = RecurringBookingMethod.until;

  Periodicity _periodicityValue = Periodicity.weekly;

  TimeOfDay _startTime;
  TimeOfDay _endTime;

  @override
  void initState() {
    super.initState();

    _startTime = TimeOfDay.fromDateTime(widget.booking.dateStart);
    _endTime = TimeOfDay.fromDateTime(widget.booking.dateEnd);

    _booking = widget.booking;

    if (_booking is RecurringBooking) {
      _recurringBookingMethod = (_booking as RecurringBooking).method;
    }
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

    if (_booking is RecurringBooking) {
      _untilController.text =
          DateFormat.yMd().format((_booking as RecurringBooking).until);
      _timesController.text = (_booking as RecurringBooking).times.toString();
    }

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CabinDropdown(
            value: _booking.cabinId,
            onChanged: (value) {
              setState(() => _booking.cabinId = value);
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
                        if (Platform.isMacOS ||
                            Platform.isWindows ||
                            Platform.isLinux) return;

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
                        if (Platform.isMacOS ||
                            Platform.isWindows ||
                            Platform.isLinux) return;

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
          ExpansionPanelList(
            expandedHeaderPadding: const EdgeInsets.all(0.0),
            expansionCallback: (index, isExpanded) {
              widget.setIsRecurring(!isExpanded);
            },
            children: [
              ExpansionPanel(
                headerBuilder: (context, isExpanded) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      widget.isRecurring
                          ? AppLocalizations.of(context).recurrence
                          : AppLocalizations.of(context).doesNotRepeat,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  );
                },
                isExpanded: widget.isRecurring,
                canTapOnHeader: true,
                body: Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
                  child: Column(
                    children: [
                      PeriodicityDropdown(
                        value: _periodicityValue,
                        onChanged: (value) {
                          setState(() => _periodicityValue = value);
                        },
                      ),
                      ListTile(
                        title: Text(AppLocalizations.of(context).until),
                        selected: _recurringBookingMethod ==
                            RecurringBookingMethod.until,
                        leading: Radio(
                          value: RecurringBookingMethod.until,
                          groupValue: _recurringBookingMethod,
                          onChanged: (value) {
                            setState(() => _recurringBookingMethod = value);
                          },
                        ),
                        trailing: SizedBox(
                          width: 100.0,
                          child: TextFormField(
                            controller: _untilController,
                            enabled: _recurringBookingMethod ==
                                RecurringBookingMethod.until,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (!widget.isRecurring ||
                                  _recurringBookingMethod !=
                                      RecurringBookingMethod.until) {
                                return null;
                              }

                              if (value.isEmpty) {
                                return AppLocalizations.of(context)
                                    .enterEndTime;
                              }

                              return null;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      ListTile(
                        title: Text(AppLocalizations.of(context).repeat),
                        selected: _recurringBookingMethod ==
                            RecurringBookingMethod.times,
                        leading: Radio(
                          value: RecurringBookingMethod.times,
                          groupValue: _recurringBookingMethod,
                          onChanged: (value) {
                            setState(() => _recurringBookingMethod = value);
                          },
                        ),
                        trailing: SizedBox(
                          width: 100.0,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 54.0,
                                child: TextFormField(
                                  controller: _timesController,
                                  enabled: _recurringBookingMethod ==
                                      RecurringBookingMethod.times,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (!widget.isRecurring ||
                                        _recurringBookingMethod !=
                                            RecurringBookingMethod.times) {
                                      return null;
                                    }

                                    if (value.isEmpty) {
                                      return AppLocalizations.of(context)
                                          .enterEndTime;
                                    }

                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              Text(AppLocalizations.of(context).times),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 32.0),
          SubmitButton(
            shouldAdd: widget.booking.studentName == null,
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();

                if (widget.isRecurring) {
                  final recurringBooking =
                      RecurringBooking.fromBooking(_booking);

                  if (_recurringBookingMethod == RecurringBookingMethod.until) {
                    recurringBooking.until =
                        DateFormat('d/M/y').parse(_untilController.text);
                  } else {
                    recurringBooking.times =
                        int.tryParse(_timesController.text);
                  }

                  Navigator.of(context).pop<RecurringBooking>(recurringBooking);
                } else {
                  Navigator.of(context).pop<Booking>(_booking);
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
