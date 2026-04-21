import 'package:flutter/material.dart';

import 'chat_page.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final friends = [
      'Calvin',
      'Matthew',
      'Gabriello',
      'Tristanto',
      'Toni',
      'Glaudio',
    ];
    final messageTimes = ['10:00', '11:15', '12:30', '13:45', '15:00', '16:20'];
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
                subtitle: const Text('Terakhir: Halo!'),
                trailing: Text(messageTimes[index % messageTimes.length]),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ChatPage(name: friends[index]),
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
}
