import 'package:flutter/material.dart';

class Batch {
  String batchName;
  String batchCentre;
  String projectName;
  String startDate;
  String endDate;

  Batch(
      {@required this.batchName,
      @required this.batchCentre,
      @required this.projectName,
      this.startDate,
      this.endDate});

  Batch.fromJson(Map<String, dynamic> json)
      : batchName = json['BATCH_NAME'],
        batchCentre = json['BATCH_CENTRE'],
        projectName = json['PROJECT_NAME'],
        startDate = json['START_DATE'],
        endDate = json['END_DATE'];

  Map<String, dynamic> toJson() =>
      {'BATCH_NAME': batchName, 'BATCH_CENTRE': batchCentre, 'PROJECT_NAME': projectName, 'START_DATE': startDate , 'END_DATE' : endDate};
}
