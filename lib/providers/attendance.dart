import 'dart:convert';

import '../models/attendance.dart';
import '../models/student.dart';
import '../providers/auth.dart';
import '../providers/students.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AttendanceList with ChangeNotifier {
  List<Attendance> _students = [];
  String authToken;
  String userId;
  bool updated = false;
  bool loadingBatches = false;

  static const BACKURL =
      'http://LmsApp-env.iy5h5ssp8k.ap-south-1.elasticbeanstalk.com';
//  static const BACKURL = 'http://10.0.2.2:3000';

  List<Attendance> get getAttendance {
    return [..._students];
  }

  bool get getStatus {
    return updated;
  }

  bool getLoader() {
    return loadingBatches;
  }

  void setAttendance(List<Student> students) {
    students.forEach((id) {
      this._students.add(new Attendance(
          batchName: id.batchName,
          name: id.name,
          bDate: '',
          status: 'No',
          rollNo: id.rollNo));
    });
    this.loadingBatches = false;
    notifyListeners();
  }

    set auth(Auth auth){
    authToken = auth.token;
    userId = auth.userId;
  }

  Future<void> fetchAttendance(
      BuildContext ctx, String batch, String bdate) async {
    this.loadingBatches = true;
    notifyListeners();
    final url = '$BACKURL/api/attendance/getAttendance';
    print("batch: $batch , bdate:$bdate");
    try {
      final response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: json.encode({'batch': batch, 'bdate': bdate}));
      final userMap = jsonDecode(response.body) as Map<String, dynamic>;
      List oData = userMap['attendance'];
      this._students = [];
      this.updated = false;
      if (oData == null || oData.isEmpty) {
        this.updated = false;
        Provider.of<StudentList>(ctx, listen: false).fetchStudents(ctx, batch);
      } else {
        oData.forEach((id) => {this._students.add(Attendance.fromJson(id))});
        this.updated = true;
        this.loadingBatches = false;
        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }
  }

  Future<bool> addOrder(List<Attendance> list) async {
    String bdate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    final url = '$BACKURL/api/attendance/addAttendance';
    list.forEach((id) {
      http.post(url,
          headers: {"Content-Type": "application/json"},
          body: json.encode({
            'name': id.name,
            'rollno': id.rollNo,
            'batch': id.batchName,
            'bdate': bdate,
            'status': id.status
          }));
      this.updated = true;
      notifyListeners();
      return true;
    });
    return false;
  }
}
