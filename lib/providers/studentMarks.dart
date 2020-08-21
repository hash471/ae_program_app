import 'dart:convert';

import 'package:ae_program_app/models/student.dart';
import 'package:ae_program_app/models/studentMarks.dart';
import 'package:ae_program_app/providers/auth.dart';
import 'package:ae_program_app/providers/students.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class StudentMarks with ChangeNotifier {
  List<StudentMark> _students = [];
  String authToken;
  String userId;
  bool updated = false;
  bool loadingBatches = false;

  static const BACKURL =
      'http://LmsApp-env.iy5h5ssp8k.ap-south-1.elasticbeanstalk.com';

 // static const BACKURL = 'http://10.0.2.2:3000';

  List<StudentMark> get getStudentMarks {
    return [..._students];
  }

  bool get getStatus {
    return updated;
  }

  bool getLoader() {
    return loadingBatches;
  }

  void setMarks(List<Student> students) {
    students.forEach((id) {
      this._students.add(new StudentMark(
          centreName: id.centreName,
          batchName: id.batchName,
          name: id.name,
          rollNo: id.rollNo,
          examName: '',
          marks: 0));
    });
    this.loadingBatches = false;
    notifyListeners();
  }

  set auth(Auth auth) {
    authToken = auth.token;
    userId = auth.userId;
  }

  Future<void> fetchStudentMarks(
      BuildContext ctx, String batch, String examName) async {
    this.loadingBatches = true;
    notifyListeners();
    final url = '$BACKURL/api/studentExams/getStudentMarks';
    try {
      final response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: json.encode({'batchName': batch, 'examName': examName}));
      final userMap = jsonDecode(response.body) as Map<String, dynamic>;
      List oData = userMap['students'];
      this._students = [];
      this.updated = false;
      if (oData == null || oData.isEmpty) {
        this.updated = false;
        Provider.of<StudentList>(ctx, listen: false).fetchStudents(ctx, batch);
      } else {
        oData.forEach((id) => {this._students.add(StudentMark.fromJson(id))});
        this.updated = true;
        this.loadingBatches = false;
        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }
  }

  Future<bool> addMarks(List<StudentMark> list) async {
    final url = '$BACKURL/api/studentExams/addStudentMarks';
    list.forEach((id) {
      http.post(url,
          headers: {"Content-Type": "application/json"},
          body: json.encode({
            'centreName': id.centreName,
            'name': id.name,
            'rollNo': id.rollNo,
            'batchName': id.batchName,
            'examName': id.examName,
            'marks': id.marks
          }));
      this.updated = true;
      notifyListeners();
      return true;
    });
    return false;
  }
}
