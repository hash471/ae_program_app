import 'package:flutter/material.dart';

class DashBoard {

  String activeBatches;
  String activeStudents;
  String totalCentres;
  String totalBatches;
  String totalStudents;
  String totalProjects;

  DashBoard(

      {
      @required this.activeBatches,
      @required this.activeStudents,
      @required this.totalCentres,
      @required this.totalBatches,
      @required this.totalStudents,
      @required this.totalProjects});

  DashBoard.fromJson(Map<String, dynamic> json)
      : totalCentres = json['TotCentres'].toString(),
        totalBatches = json['TotBatches'].toString(),
        totalStudents = json['TotStudents'].toString(),
        totalProjects = json['TotProjects'].toString(),
        activeBatches = json['ActiveBatches'].toString(),
        activeStudents = json['ActiveStudents'].toString();
}
