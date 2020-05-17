import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:chaloapp/global_colors.dart';

class DateTimePicker {
  static DateTime _pickedDate;
  static TimeOfDay _pickedTime;

  Future<DateTime> presentDatePicker(
      BuildContext ctx, DateTime first, DateTime last) async {
    _pickedDate = await showDatePicker(
      context: ctx,
      firstDate: first,
      initialDate: _pickedDate ?? DateTime.now(),
      lastDate: last,
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(primary: Color(primary)),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child,
        );
      },
    );
    return _pickedDate;
  }

  Future<DateTime> presentTimePicker(BuildContext ctx, DateTime time) async {
    _pickedTime = await showTimePicker(
      context: ctx,
      initialTime: time == null
          ? TimeOfDay.fromDateTime(DateTime.now())
          : TimeOfDay.fromDateTime(time),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Color(primary),
            accentColor: Color(primary),
            colorScheme: ColorScheme.light(primary: Color(primary)),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child,
        );
      },
    );
    return DateTimeField.convert(_pickedTime);
  }
}
