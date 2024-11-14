import 'package:flutter/material.dart';

class CleanCalendarEvent {
  String summary;
  String description;
  String location;
  String clockIn;
  String clockOut;
  bool isDevice;
  DateTime startTime;
  DateTime endTime;
  Color color;
  bool isAllDay;
  bool isDone;

  CleanCalendarEvent(this.summary,
      {this.description = '',
        this.location = '',
        this.clockIn = '',
        this.clockOut = '',
        this.isDevice = false,
        @required this.startTime,
        @required this.endTime,
        this.color = Colors.blue,
        this.isAllDay = false,
        this.isDone = false});
}
