import 'package:flutter/material.dart';

import 'chat_page.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({
    super.key,
    required this.friends,
    required this.directMessages,
    required this.onSendMessage,
  });

  final List<String> friends;
  final Map<String, List<Map<String, String>>> directMessages;
  final void Function(String friendName, Map<String, String> message) onSendMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Pesan',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: friends.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text(friends[index]),
                subtitle: Text(_lastMessagePreview(friends[index])),
                trailing: const Text('14:30'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ChatPage(
                        name: friends[index],
                        messages: directMessages[friends[index]]!,
                        onSendMessage: (message) => onSendMessage(friends[index], message),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  String _lastMessagePreview(String friend) {
    final messages = directMessages[friend] ?? const <Map<String, String>>[];
    if (messages.isEmpty) {
      return 'Terakhir: $friend';
    }

    final latest = messages.last;
    if (latest['type'] == 'pin') {
      return 'Terakhir: Pin ${latest['title'] ?? 'Gwaith'}';
    }

    return 'Terakhir: ${latest['text'] ?? ''}';
  }
}
