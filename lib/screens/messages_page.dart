import 'package:flutter/material.dart';

import 'chat_page.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final friends = [
      'Calvin',
      'Ello',
      'Theo',
      'Wellsi',
      'Bagas',
      'Putra',
    ];

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
                subtitle: Text('Terakhir: ${friends[index]}'),
                trailing: const Text('14:30'),
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
