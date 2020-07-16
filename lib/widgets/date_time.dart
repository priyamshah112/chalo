import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import '../common/global_colors.dart';

class DateTimePicker {
  DateTime _pickedDate;
  TimeOfDay _pickedTime;

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

  Future<DateTime> presentDateTimePicker(
      BuildContext ctx, DateTime first, DateTime last, DateTime time) async {
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
    if (_pickedDate != null) {
      _pickedTime = await showTimePicker(
        context: ctx,
        initialTime:
            _pickedTime ?? TimeOfDay.fromDateTime(time ?? DateTime.now()),
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
      // print('picker: ' +
      //     DateTimeField.combine(_pickedDate, _pickedTime).toString());
    }
    return _pickedDate == null || _pickedTime == null
        ? time
        : DateTimeField.combine(_pickedDate, _pickedTime);
  }
}
