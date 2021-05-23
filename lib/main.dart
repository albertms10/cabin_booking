import 'dart:io';

import 'package:cabin_booking/widgets/cabin_booking_app.dart';
import 'package:cabin_booking/model/cabin_manager.dart';
import 'package:cabin_booking/model/day_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowMinSize(const Size(400, 600));
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DayHandler()),
        ChangeNotifierProvider(create: (context) => CabinManager()),
      ],
      child: const CabinBookingApp(),
    ),
  );
}
