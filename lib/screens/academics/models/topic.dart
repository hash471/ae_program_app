import 'package:flutter/material.dart' show required;

class Topic {
  final String name;
  final bool isCompleted;
  final bool canEdit;

  Topic({
    @required this.name,
    @required this.isCompleted,
    @required this.canEdit,
  });

  factory Topic.fromJson(Map<String, dynamic> map) {
    return Topic(
      name: map['TOPIC'] as String,
      isCompleted: (map['COMPLETED'] as String) == 'Y',
      canEdit: (map['COMPLETED'] as String) == 'N',
    );
  }

  Topic toggleCompleted() {
    return Topic(
      name: name,
      isCompleted: !isCompleted,
      canEdit: canEdit,
    );
  }

  Topic markUnEditable() {
    return Topic(
      name: name,
      isCompleted: true,
      canEdit: false,
    );
  }
}
