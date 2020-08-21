import 'dart:convert';

import 'package:ae_program_app/models/student.dart';
import 'package:ae_program_app/models/studentMarks.dart';
import 'package:ae_program_app/providers/attendance.dart';
import 'package:ae_program_app/providers/auth.dart';
import 'package:ae_program_app/providers/studentMarks.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class StudentList with ChangeNotifier {
  List<Student> _students = [];
  String authToken;
  String userId;

static const BACKURL = 'http://LmsApp-env.iy5h5ssp8k.ap-south-1.elasticbeanstalk.com' ;
//  static const BACKURL = 'http://10.0.2.2:3000';

  List<Student> get getStudents {
    return [..._students];
  }

  set auth(Auth auth) {
    authToken = auth.token;
    userId = auth.userId;
  }

  Future<void> fetchStudents(BuildContext ctx, String batch) async {
    final url = '$BACKURL/api/appStudents/getStudents';
    print('on tje student provider');
    try {
      final response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: json.encode({'batch': batch}));
      print(response);
      final userMap = jsonDecode(response.body) as Map<String, dynamic>;
      List oData = userMap['students'];
      this._students = [];
      print(this._students);
      if (oData == null) {
      } else {
        oData.forEach((id) => {this._students.add(Student.fromJson(id))});
        Provider.of<AttendanceList>(ctx, listen: false)
            .setAttendance(this._students);
        Provider.of<StudentMarks>(ctx, listen: false)
            .setMarks(this._students);
        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }
  }
}
