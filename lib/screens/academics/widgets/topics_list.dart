import 'package:app/providers/academics_provider.dart';
import 'package:app/screens/academics/models/topic.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopicsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AcademicsProvider>(
      builder: (context, provider, child) {
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          itemCount: provider.topics.length,
          itemBuilder: (context, index) {
            final topic = provider.topics[index];
            return ListTile(
              leading: Checkbox(
                value: topic.isCompleted,
                activeColor: Color(0xff83BB40),
                onChanged: topic.canEdit
                    ? (val) => _onTopicPressed(context, topic)
                    : null,
              ),
              enabled: topic.canEdit,
              title: Text(
                topic.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                topic.isCompleted ? 'Topic completed' : 'Topic not completed',
              ),
              onTap: () => _onTopicPressed(context, topic),
            );
          },
        );
      },
    );
  }

  void _onTopicPressed(BuildContext context, Topic topic) {
    final academicsProvider =
        Provider.of<AcademicsProvider>(context, listen: false);
    academicsProvider.toggleFromChangedTopics(topic);
    academicsProvider.updateTopics(topic.toggleCompleted());
  }
}
