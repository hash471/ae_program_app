import 'package:flutter/material.dart';

class Centre {
  String centreName;
  String centreProject;

  Centre(
      {@required this.centreName,
      @required this.centreProject});

  Centre.fromJson(Map<String, dynamic> json)
      : centreName = json['CENTRE_NAME'],
        centreProject = json['CENTRE_PROJECT'];

  Map<String, dynamic> toJson() =>
      {'CENTRE_NAME': centreName, 'CENTRE_PROJECT': centreProject};
}