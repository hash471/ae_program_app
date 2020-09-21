import 'dart:convert';

import '../models/centre.dart';
import '../providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CentreList with ChangeNotifier {
  List<Centre> _centres = [];
  List<String> _centreNames = ['Select Centre'];
  String authToken;
  String userId;
  bool loadingCentre = false;

  static const BACKURL =
      'http://LmsApp-env.iy5h5ssp8k.ap-south-1.elasticbeanstalk.com';
//  static const BACKURL = 'http://10.0.2.2:3000';

  List<Centre> get getCentres {
    return [..._centres];
  }

  bool getStatus() {
    return loadingCentre;
  }

  List<String> get getCentreNames {
    return [..._centreNames];
  }

  set auth(Auth auth){
    authToken = auth.token;
    userId = auth.userId;
  }

  Future<void> fetchCentres() async {
    this.loadingCentre = true;
    final url = '$BACKURL/api/appBranches/getBranches';
    try {
      final response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: json.encode({'phone': 'banners'}));
      print(response);
      final userMap = jsonDecode(response.body) as Map<String, dynamic>;
      List oData = userMap['centres'];
      this._centres = [];
      if (oData == null) {
        this.loadingCentre = false;
        this._centreNames = [];
        this._centreNames.add('Select Centre');
        notifyListeners();
      } else {
        oData.forEach((id) => {this._centres.add(Centre.fromJson(id))});
        this.loadingCentre = false;
        this._centreNames = [];
        this._centreNames.add('Select Centre');
        this._centres.forEach((id) => {this._centreNames.add(id.centreName)});
        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }
  }
}
