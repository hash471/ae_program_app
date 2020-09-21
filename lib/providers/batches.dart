import 'dart:convert';

import '../models/batch.dart';
import '../providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BatchList with ChangeNotifier {
  List<Batch> _batches = [];
  List<String> _batchNames = ['Select Batch'];
  String authToken;
  String userId;
  bool loadingBatches = false;

static const BACKURL = 'http://LmsApp-env.iy5h5ssp8k.ap-south-1.elasticbeanstalk.com' ;
//  static const BACKURL = 'http://10.0.2.2:3000';

  List<Batch> get getBatches {
    return [..._batches];
  }

  bool getStatus() {
    return loadingBatches;
  }

  void refreshBatches() {
    this._batchNames = [];
    this._batchNames.add('Select Batch');
  }

  List<String> get getBatchNames {
    return [..._batchNames];
  }

  set auth(Auth auth){
    authToken = auth.token;
    userId = auth.userId;
  }

  Future<void> fetchBatches(String centre) async {
    this.loadingBatches = true;
    final url = '$BACKURL/api/appBatches/getBatches';
    try {
      final response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: json.encode({'centre': centre}));
      print(response);
      final userMap = jsonDecode(response.body) as Map<String, dynamic>;
      List oData = userMap['batches'];
      this._batches = [];
      if (oData == null) {
        this.loadingBatches = false;
        this._batchNames = [];
        this._batchNames.add('Select Batch');
        notifyListeners();
      } else {
        oData.forEach((id) => {this._batches.add(Batch.fromJson(id))});
        this._batchNames = [];
        this._batchNames.add('Select Batch');
        this._batches.forEach((id) => {this._batchNames.add(id.batchName)});
        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }
  }
}
