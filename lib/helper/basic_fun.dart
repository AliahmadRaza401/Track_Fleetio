import 'package:intl/intl.dart';

dateTimeFormater(date) {
  final DateFormat formatter = DateFormat.yMd().add_jm();
  // DateFormat('yyyy-MM-dd – kk:mm a');
  final String formatted = formatter.format(date);
  return formatted;
}
