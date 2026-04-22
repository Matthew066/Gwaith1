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
  final void Function(String friendName, Map<String, String> message)
  onSendMessage;

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
              final friendName = friends[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                    'https://picsum.photos/seed/${friendName.hashCode}/200',
                  ),
                ),
                title: Text(friendName),
                subtitle: Text(_lastMessagePreview(friendName)),
                trailing: const Text('14:30'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ChatPage(
                        name: friendName,
                        messages: directMessages[friendName]!,
                        onSendMessage: (message) =>
                            onSendMessage(friendName, message),
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
