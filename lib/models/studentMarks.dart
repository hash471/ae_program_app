import 'dart:io';

import 'package:flutter/material.dart';

class StudentMark {
  String batchName;
  String examName;
  String name;
  String centreName;
  String rollNo;
  int marks;

  StudentMark(
      {@required this.batchName,
      @required this.name,
      @required this.centreName,
      @required this.rollNo,
      @required this.examName,
      @required this.marks});

  StudentMark.fromJson(Map<String, dynamic> json)
      : batchName = json['BATCH_NAME'],
        name = json['NAME'],
        rollNo = json['ROLL_NO'],
        centreName = json['CENTRE_NAME'],
        examName = json['EXAM_TYPE'],
        marks = int.parse(json['MARKS']);

  Map<String, dynamic> toJson() => {
        'BATCH_NAME': batchName,
        'CENTRE_NAME': centreName,
        'NAME': name,
        'ROLL_NO': rollNo,
        'MARKS': marks,
        'EXAM_TYPE': examName
      };
}
