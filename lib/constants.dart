import 'package:flutter/material.dart';

// Bookings timetable.
const kBookingHeightRatio = 2.2;
const kBookingHeaderHeight = 105.0;
const kTimeColumnWidth = 100.0;
const kBookingColumnMinWidth = 150.0;

const kTimeTableStartTime = TimeOfDay(hour: 9, minute: 0);
const kTimeTableEndTime = TimeOfDay(hour: 22, minute: 0);

// Booking slot.
const kMinSlotDuration = Duration(minutes: 20);
const kMaxSlotDuration = Duration(minutes: 60);

// Weekdays.
const nonSchoolWeekdays = {DateTime.saturday, DateTime.sunday};

// Regular expressions.
const timeExpression = r'\d{1,2}[.:]\d{2}';
