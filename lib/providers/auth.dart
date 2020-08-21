import 'dart:convert';
import 'dart:async';

import 'package:ae_program_app/models/trainer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  static const BACKURL =
      'http://LmsApp-env.iy5h5ssp8k.ap-south-1.elasticbeanstalk.com';
  // static const BACKURL = 'http://10.0.2.2:3000';

  String _token;
  bool _userStat = false;
  String _number;
  DateTime _expiryDate;
  String _userId;
  Trainer trainer;
  Timer authTimer;
  bool _authFailed = false;

  bool get userStat {
    return _userStat;
  }

  bool getAuthStatus() {
    return _authFailed;
  }

  Trainer getTrainer() {
    return trainer;
  }

  Future<void> setTken(String tkn, String number) async {
    this._token = tkn;
    this._number = number;
    this._userId = this._number;

    _expiryDate = DateTime.now().add(
      Duration(seconds: 7200),
    );

    notifyListeners();
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences pref = await _prefs;
    _prefs.then((pref) {
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String()
      });
      print(userData);
      pref.setString('userData', userData);
    });
    notifyListeners();
  }

  String get number {
    return _number;
  }

  bool get isUser {
    return _userStat;
  }

  String get token {
    return _token;
  }

  String get userId {
    return _userId;
  }

  bool get isAuth {
    return _token != null;
    //   return true;
  }

  Future<bool> signIn(
      String username, String password, BuildContext context) async {
    var ipwd = password;
    var iusr = username;

    const url = '$BACKURL/api/trainers/check';
    print(this._number);
    print(url);

    final sresponse = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({'email': iusr, 'password': ipwd}));
    final userMap = jsonDecode(sresponse.body) as Map<String, dynamic>;
    print(userMap);
    List oData = userMap['trainers'];
    print(oData);
    if (oData.isEmpty) {
      this._authFailed = true;
      notifyListeners();
    } else {
      this.trainer = Trainer.fromJson(oData[0]);
      this._token = 'token';
      this._number = this.trainer.contact;
      this._userId = this.trainer.employeeID;
      _expiryDate = DateTime.now().add(
        Duration(seconds: 7200),
      );
      notifyListeners();
      Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
      final SharedPreferences pref = await _prefs;
      _prefs.then((pref) {
        final userData = json.encode({
          'token': _token,
          'trainer': trainer,
          'userId': _userId,
          'expiryDate': _expiryDate.toIso8601String()
        });
        print(userData);
        pref.setString('userData', userData);
      });
      notifyListeners();
    }
  }

  Future<bool> tryAutoLogin(BuildContext ctx) async {
    print('here to check pref');
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      print('didnt find key');
      return false;
    }
    final userData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    _token = userData['token'];
    final expiryDate = DateTime.parse(userData['expiryDate']);
    this._token = userData['token'];
    this.trainer = Trainer.fromJson(userData['trainer']);
    this._userId = userData['userId'];
    this._number = this._userId;
    if (_userId == null) {
      notifyListeners();
      return false;
    } else {
      notifyListeners();
      return true;
    }
  }

  Future<void> logout() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences pref = await _prefs;
    pref.remove('userData');
    this.trainer = null;
    this._token = null;
    this._userId = null;
    this._expiryDate = null;
    if (authTimer != null) {
      authTimer.cancel();
    }
    authTimer = null;
    notifyListeners();
  }
}
