import 'dart:convert';

import 'package:app/screens/academics/models/topic.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AcademicsProvider extends ChangeNotifier {
  String _trainingType = '';
  String get trainingType => _trainingType;

  int _days = 0;
  int get days => _days;

  int _selectedDay = 0;
  int get selectedDay => _selectedDay;

  String _batchName = '';
  String get batchName => _batchName;

  List<Topic> _topics = [];
  List<Topic> get topics => _topics;

  Map<String, Topic> _changedTopics = {};
  bool get hasChanges => _changedTopics.isNotEmpty;

  void init() {
    _trainingType = '';
    _days = 0;
  }

  void _reset() {
    _trainingType = '';
    _days = 0;
    _selectedDay = 0;
    _topics = [];
    _changedTopics = {};
  }

  void updateBatchNameTo(String batchName) {
    if (_batchName != batchName) {
      _batchName = batchName;
      _reset();
    }
  }

  void setSelectedDay(int day) {
    if (day != _selectedDay) {
      _selectedDay = day;
      _fetchBatchTopicsByDay(_selectedDay);
      notifyListeners();
    }
  }

  void updateTopics(Topic topic) {
    final index = _topics.indexWhere((t) => t.name == topic.name);
    _topics.removeAt(index);
    _topics.insert(index, topic);
    notifyListeners();
  }

  void _updateTopicToUnEditable(Topic topic) {
    final index = _topics.indexWhere((t) => t.name == topic.name);
    _topics.removeAt(index);
    _topics.insert(index, topic.markUnEditable());
    notifyListeners();
  }

  void toggleFromChangedTopics(Topic topic) {
    if (_changedTopics.containsKey(topic.name)) {
      _changedTopics.remove(topic.name);
    } else {
      _changedTopics[topic.name] = topic;
    }
  }

  Future<void> applyChangesToCurrent() async {
    for (final topic in _changedTopics.values) {
      final response = await http.post(
        'http://lmsapp-env.iy5h5ssp8k.ap-south-1.elasticbeanstalk.com/api/batchSchedule/addBatchTopic',
        body: {
          'batchName': _batchName,
          'topic': topic.name,
          'topicStatus': 'Completed',
          'bDay': '$_selectedDay',
        },
      );
      final map = jsonDecode(response.body);
      final submitted = map['message'] == 'Days retreived Succesfully';
      if (submitted) {
        _updateTopicToUnEditable(topic);
      }
    }
    _changedTopics = {};
  }

  Future<void> _fetchBatchTopicsByDay(int selectedDay) async {
    final response = await http.post(
      'http://lmsapp-env.iy5h5ssp8k.ap-south-1.elasticbeanstalk.com/api/batchSchedule/getBatchTopicsByDay',
      body: {
        'trainingType': _trainingType,
        'batchName': _batchName,
        'bDay': '$selectedDay',
      },
    );
    final json = jsonDecode(response.body);
    final schedules = json['schedules'];
    _topics = [];
    _changedTopics = {};
    if (schedules.length != 0) {
      for (final schedule in schedules) {
        _topics.add(Topic.fromJson(schedule));
      }
    }
    notifyListeners();
  }

  Future<bool> fetchNumberOfDaysGiven(String batchName) async {
    final response = await http.post(
      'http://lmsapp-env.iy5h5ssp8k.ap-south-1.elasticbeanstalk.com/api/batchSchedule/getBatchTopic',
      body: {'batchName': batchName},
    );
    bool areTopicsAvailable = false;
    final json = jsonDecode(response.body);
    final schedules = json['schedules'];
    if (schedules.length != 0) {
      _trainingType = schedules[0]['TRAINING_TYPE'] as String;
      _days = schedules[0]['DAYS'] as int;
      areTopicsAvailable = true;
    } else {
      _reset();
      areTopicsAvailable = false;
    }
    notifyListeners();
    return areTopicsAvailable;
  }
}
