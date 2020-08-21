import 'package:flutter/material.dart';

class BatchExam {
  String centreName;
  String batchName;
  String examType;
  String examName;
  String examDate;
  String paperUrl;
  int maxMarks;

  BatchExam(
      {@required this.centreName,
      @required this.batchName,
      @required this.examType,
      @required this.examName,
      @required this.examDate,
      @required this.paperUrl,
      @required this.maxMarks});

  BatchExam.fromJson(Map<String, dynamic> json)
      : batchName = json['BATCH_NAME'],
        centreName = json['CENTRE_NAME'],
        examType = json['EXAM_TYPE'],
        examName = json['EXAM_NAME'],
        examDate = json['EXAM_DATE'],
        paperUrl = json['PAPER_URL'],
        maxMarks = json['MAX_MARKS'];

  Map<String, dynamic> toJson() => {
        'BATCH_NAME': batchName,
        'CENTRE_NAME': centreName,
        'EXAM_TYPE': examType,
        'EXAM_NAME': examName,
        'EXAM_DATE': examDate,
        'PAPER_URL': paperUrl,
        'MAX_MARKS' : maxMarks
      };
}
