import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'day_process_page.dart';

/// Claude code
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const DayProcessPage());
}
