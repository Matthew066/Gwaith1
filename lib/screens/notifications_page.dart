import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final users = [
      'Calvin',
      'Ello',
      'Theo',
      'Wellsi',
      'Bagas',
      'Putra',
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10,
      itemBuilder: (context, index) {
        final user = users[index % users.length];

        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=$user'),
          ),
          title: Text('$user menyukai Pin Anda'),
          subtitle: const Text('2 jam yang lalu'),
          trailing: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: const DecorationImage(
                image: NetworkImage('https://picsum.photos/100'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
}
