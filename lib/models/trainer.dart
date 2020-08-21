import 'package:flutter/material.dart';

class Trainer {
  String employeeID;
  String name;
  String expertise;
  String email;
  String contact;

  Trainer(
      {@required this.employeeID,
      @required this.name,
      @required this.email,
      @required this.expertise,
      @required this.contact});

  Trainer.fromJson(Map<String, dynamic> json)
      : employeeID = json['EMPLOYEE_ID'],
        name = json['EMPLOYEE_NAME'],
        expertise = json['DESIGNATION'],
        email = json['EMAIL'],
        contact = json['CONTACT'];

  Map<String, dynamic> toJson() => {
        'EMPLOYEE_ID': employeeID,
        'EMPLOYEE_NAME': name,
        'DESIGNATION': expertise,
        'EMAIL': email,
        'CONTACT': contact
      };
}
