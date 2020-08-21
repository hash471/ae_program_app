import 'package:flutter/material.dart';

class Attendance {
  String bDate;
  String batchName;
  String name;
  String rollNo;
  String status;

  Attendance(
      {@required this.batchName,
      @required this.name,
      @required this.bDate,
      @required this.status,
      @required this.rollNo});

  Attendance.fromJson(Map<String, dynamic> json)
      : batchName = json['BATCH'],
        name = json['NAME'],
        rollNo = json['ROLLNO'],
        status = json['STATUS'],
        bDate = json['BDATE'];

  Map<String, dynamic> toJson() =>
      {'BATCH': batchName, 'BDATE': bDate, 'NAME' : name, 'ROLLNO': rollNo, 'STATUS' : status};
}