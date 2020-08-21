import 'package:flutter/material.dart';

class Student {
  String batchName;
  String name;
  String centreName;
  String rollNo;

  Student(
      {@required this.batchName,
      @required this.name,
      @required this.centreName,
      @required this.rollNo});

  Student.fromJson(Map<String, dynamic> json)
      : batchName = json['BATCH_NAME'],
        name = json['NAME'],
        rollNo = json['ROLL_NO'],
        centreName = json['CENTRE_NAME'];

  Map<String, dynamic> toJson() =>
      {'BATCH_NAME': batchName, 'CENTRE_NAME': centreName, 'NAME' : name, 'ROLL_NO': rollNo};
}