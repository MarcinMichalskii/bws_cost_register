import 'package:intl/intl.dart';

extension DateExtensions on DateTime {
  String get formattedDate => DateFormat('MM.yyyy').format(this);
  String get formattedDateWithDays => DateFormat('dd.MM.yyyy').format(this);
  String get formattedTime => DateFormat('HH:mm').format(this);
}
