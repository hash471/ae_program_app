import 'dart:convert';

import 'package:ae_program_app/models/batchExam.dart';
import 'package:ae_program_app/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BatchExams with ChangeNotifier {
  List<BatchExam> _exams = [];
  String authToken;
  String userId;
  bool updated = false;
  bool loadingBatches = false;

  static const BACKURL =
      'http://LmsApp-env.iy5h5ssp8k.ap-south-1.elasticbeanstalk.com';
//  static const BACKURL = 'http://10.0.2.2:3000';

  List<BatchExam> get getBatchExams {
    return [..._exams];
  }

  int maxMarks(String examName) {
    int maxMarks;
    this._exams.forEach((id) {
      if (id.examName == examName) {
        maxMarks = id.maxMarks;
      }
    });
    return maxMarks;
  }

  bool get getStatus {
    return updated;
  }

  List<String> getExamTypes(String batchName) {
    List<String> examTypes = [];
    this._exams.forEach((id) {
      if (examTypes.length == 0) {
        examTypes.add(id.examType);
        print(id.examType);
      } else {
        int ind = examTypes.indexOf(id.examType);
        if (ind < 0) {
          examTypes.add(id.examType);
          print(id.examType);
        }
      }
    });
    print(examTypes);
    notifyListeners();
    return examTypes;
  }

  List<String> getExamNames(String examType) {
    List<String> examNames = [];
    this._exams.forEach((id) {
      if (id.examType == examType) {
        examNames.add(id.examName);
      }
    });
    notifyListeners();
    return examNames;
  }

  bool getLoader() {
    return loadingBatches;
  }

  set auth(Auth auth) {
    authToken = auth.token;
    userId = auth.userId;
  }

  Future<void> fetchBatchExams(
      BuildContext ctx, String batch, String centre) async {
    this.loadingBatches = true;
    print('$batch $centre');
    notifyListeners();
    final url = '$BACKURL/api/batchExams/getBatchExams';
    try {
      final response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: json.encode({'batchName': batch, 'centreName': centre}));
      final userMap = jsonDecode(response.body) as Map<String, dynamic>;
      List oData = userMap['exams'];
      this._exams = [];
      this.updated = false;
      if (oData == null || oData.isEmpty) {
        this.updated = true;
      } else {
        oData.forEach((id) => {this._exams.add(BatchExam.fromJson(id))});
        this.updated = true;
        this.loadingBatches = false;
        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }
  }
}
