import 'dart:io' show Platform;

import 'package:cabin_booking/constants.dart';
import 'package:cabin_booking/model.dart';
import 'package:cabin_booking/utils/date_time_extension.dart';
import 'package:cabin_booking/utils/time_of_day_extension.dart';
import 'package:cabin_booking/widgets/booking/periodicity_list_tile.dart';
import 'package:cabin_booking/widgets/cabin/cabin_dropdown.dart';
import 'package:cabin_booking/widgets/layout/date_form_field.dart';
import 'package:cabin_booking/widgets/layout/item_info.dart';
import 'package:cabin_booking/widgets/layout/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BookingForm extends StatefulWidget {
  final Booking booking;
  final bool isRecurring;
  final void Function(bool) setIsRecurring;

  const BookingForm({
    Key? key,
    required this.booking,
    this.isRecurring = false,
    required this.setIsRecurring,
  }) : super(key: key);

  @override
  _BookingFormState createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  final _formKey = GlobalKey<FormState>();

  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  final _endDateController = TextEditingController();
  final _occurrencesController = TextEditingController();

  late Booking _booking = widget.booking;

  RecurringBookingMethod _recurringBookingMethod =
      RecurringBookingMethod.endDate;
  Periodicity _periodicity = Periodicity.weekly;

  late TimeOfDay? _startTime = widget.booking.startTime;
  late TimeOfDay? _endTime = widget.booking.endTime;

  DateTime? _recurringEndDate;

  @override
  void initState() {
    super.initState();

    if (_booking is RecurringBooking) {
      _recurringBookingMethod = (_booking as RecurringBooking).method;
      _periodicity = (_booking as RecurringBooking).periodicity;
      _recurringEndDate = (_booking as RecurringBooking).recurringEndDate;

      _endDateController.text = DateFormat.yMd()
          .format((_booking as RecurringBooking).recurringEndDate);
    }
  }

  @override
  void dispose() {
    _startTimeController.dispose();
    _endTimeController.dispose();
    _endDateController.dispose();
    _occurrencesController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    _startTimeController.text = _startTime!.format(context);
    _endTimeController.text = _endTime!.format(context);

    if (_booking is RecurringBooking) {
      _occurrencesController.text =
          (_booking as RecurringBooking).occurrences.toString();
    }

    return Form(
      key: _formKey,
      child: Column(
        children: [
          CabinDropdown(
            value: _booking.cabinId!,
            onChanged: (value) {
              setState(() => _booking.cabinId = value);
            },
          ),
          const SizedBox(height: 24.0),
          TextFormField(
            initialValue: widget.booking.description,
            autofocus: true,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return _booking.isLocked
                    ? appLocalizations.enterDescription
                    : appLocalizations.enterStudentName;
              }

              return null;
            },
            onSaved: (value) {
              _booking.description = value;
            },
            decoration: InputDecoration(
              labelText: _booking.isLocked
                  ? appLocalizations.description
                  : appLocalizations.student,
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
                        if (value == null || value.isEmpty) {
                          return appLocalizations.enterStartTime;
                        }

                        final parsedTimeOfDay =
                            TimeOfDayExtension.tryParse(value);

                        if (parsedTimeOfDay == null) {
                          return appLocalizations.enterStartTime;
                        }

                        _booking.startTime = parsedTimeOfDay;

                        if (_startTime != parsedTimeOfDay) {
                          _startTime = parsedTimeOfDay;
                        }

                        final parsedDateTime =
                            widget.booking.date!.addTimeOfDay(parsedTimeOfDay);

                        if (parsedDateTime.isAfter(
                              widget.booking.date!.addTimeOfDay(_endTime),
                            ) ||
                            parsedDateTime.isBefore(
                              widget.booking.date!
                                  .addTimeOfDay(kTimeTableStartTime),
                            )) {
                          return appLocalizations.enterValidRange;
                        }

                        if (cabinManager
                            .cabinFromId(_booking.cabinId)
                            .bookingsCollideWith(_booking)) {
                          return appLocalizations.occupied;
                        }

                        return null;
                      },
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: _startTime!,
                          initialEntryMode: Platform.isMacOS ||
                                  Platform.isWindows ||
                                  Platform.isLinux
                              ? TimePickerEntryMode.input
                              : TimePickerEntryMode.dial,
                        );

                        if (time == null) return;

                        setState(() {
                          _startTime = time;
                          _startTimeController.text = time.format(context);
                        });
                      },
                      onSaved: (value) {
                        _booking.startTime =
                            TimeOfDayExtension.tryParse(value ?? '');
                      },
                      decoration: InputDecoration(
                        labelText: appLocalizations.start,
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
                        if (value == null || value.isEmpty) {
                          return appLocalizations.enterEndTime;
                        }

                        final parsedTimeOfDay =
                            TimeOfDayExtension.tryParse(value);

                        if (parsedTimeOfDay == null) {
                          return appLocalizations.enterEndTime;
                        }

                        _booking.endTime = parsedTimeOfDay;

                        if (_endTime != parsedTimeOfDay) {
                          _endTime = parsedTimeOfDay;
                        }

                        final parsedDateTime =
                            widget.booking.date!.addTimeOfDay(parsedTimeOfDay);

                        if (parsedDateTime.isBefore(
                              widget.booking.date!.addTimeOfDay(_startTime),
                            ) ||
                            parsedDateTime.isAfter(
                              widget.booking.date!
                                  .addTimeOfDay(kTimeTableEndTime),
                            )) {
                          return appLocalizations.enterValidRange;
                        }

                        if (cabinManager
                            .cabinFromId(_booking.cabinId)
                            .bookingsCollideWith(_booking)) {
                          return appLocalizations.occupied;
                        }

                        return null;
                      },
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: _endTime!,
                          initialEntryMode: Platform.isMacOS ||
                                  Platform.isWindows ||
                                  Platform.isLinux
                              ? TimePickerEntryMode.input
                              : TimePickerEntryMode.dial,
                        );

                        if (time == null) return;

                        setState(() {
                          _endTime = time;
                          _endTimeController.text = time.format(context);
                        });
                      },
                      onSaved: (value) {
                        _booking.endTime =
                            TimeOfDayExtension.tryParse(value ?? '');
                      },
                      decoration: InputDecoration(
                        labelText: appLocalizations.end,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 32.0),
          ExpansionPanelList(
            expandedHeaderPadding: EdgeInsets.zero,
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
                          ? appLocalizations.recurrence
                          : appLocalizations.doesNotRepeat,
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
                      PeriodicityListTile(
                        value: _periodicity,
                        onChanged: (value) {
                          setState(() => _periodicity = value!);
                        },
                      ),
                      ListTile(
                        minVerticalPadding: 24.0,
                        title: Text(appLocalizations.onDate),
                        selected: _recurringBookingMethod ==
                            RecurringBookingMethod.endDate,
                        leading: Radio<RecurringBookingMethod>(
                          value: RecurringBookingMethod.endDate,
                          groupValue: _recurringBookingMethod,
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() => _recurringBookingMethod = value);
                          },
                        ),
                        trailing: SizedBox(
                          width: 154.0,
                          child: DateFormField(
                            controller: _endDateController,
                            enabled: _recurringBookingMethod ==
                                RecurringBookingMethod.endDate,
                            initialDate: _recurringEndDate,
                            firstDate: DateTime.now(),
                            skipValidation: !widget.isRecurring ||
                                _recurringBookingMethod !=
                                    RecurringBookingMethod.endDate,
                            onChanged: (date) {
                              setState(() => _recurringEndDate = date);
                            },
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          appLocalizations.after(
                            int.tryParse(_occurrencesController.text) ?? 0,
                          ),
                        ),
                        selected: _recurringBookingMethod ==
                            RecurringBookingMethod.occurrences,
                        minVerticalPadding: 24.0,
                        leading: Radio<RecurringBookingMethod>(
                          value: RecurringBookingMethod.occurrences,
                          groupValue: _recurringBookingMethod,
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() => _recurringBookingMethod = value);
                          },
                        ),
                        trailing: SizedBox(
                          width: 154.0,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 54.0,
                                child: TextFormField(
                                  controller: _occurrencesController,
                                  enabled: _recurringBookingMethod ==
                                      RecurringBookingMethod.occurrences,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  validator: (value) {
                                    if (!widget.isRecurring ||
                                        _recurringBookingMethod !=
                                            RecurringBookingMethod
                                                .occurrences) {
                                      return null;
                                    }

                                    if (value == null || value.isEmpty) {
                                      return appLocalizations.enterOccurrences;
                                    }

                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              Text(
                                appLocalizations.nOccurrences(
                                  int.tryParse(_occurrencesController.text) ??
                                      0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32.0),
          SubmitButton(
            shouldAdd: widget.booking.description == null,
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                if (widget.isRecurring) {
                  final recurringBooking = RecurringBooking.fromBooking(
                    _booking,
                    periodicity: _periodicity,
                    recurringEndDate: _recurringBookingMethod ==
                            RecurringBookingMethod.endDate
                        ? DateFormat.yMd().parseLoose(_endDateController.text)
                        : null,
                    occurrences: _recurringBookingMethod ==
                            RecurringBookingMethod.occurrences
                        ? int.tryParse(_occurrencesController.text)
                        : null,
                  );

                  Navigator.of(context).pop<RecurringBooking>(recurringBooking);
                } else {
                  if (_booking is RecurringBooking) {
                    _booking =
                        (_booking as RecurringBooking).asBooking(linked: false);
                  }

                  Navigator.of(context).pop<Booking>(_booking);
                }
              }
            },
          ),
          if (widget.booking.description != null)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ItemInfo(
                creationDateTime: widget.booking.creationDateTime,
                modificationDateTime: widget.booking.modificationDateTime,
                modificationCount: widget.booking.modificationCount,
              ),
            ),
        ],
      ),
    );
  }
}
