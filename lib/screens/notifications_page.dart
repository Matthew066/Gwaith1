import 'dart:math';

import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late final List<Map<String, String>> _notifications;
  final _random = Random();

  final _friends = [
    'Calvin',
    'Matthew',
    'Gabriello',
    'Tristanto',
    'Toni',
    'Glaudio',
  ];

  final _actions = ['menyukai Pin Anda', 'menyukai papan Anda'];

  @override
  void initState() {
    super.initState();
    _notifications = List.generate(15, (index) {
      final friend = _friends[_random.nextInt(_friends.length)];
      final action = _actions[_random.nextInt(_actions.length)];

      final timeUnitOptions = ['detik', 'menit', 'jam', 'hari', 'bulan'];
      final timeUnit = timeUnitOptions[_random.nextInt(timeUnitOptions.length)];
      int time = 1;

      switch (timeUnit) {
        case 'detik':
        case 'menit':
          time = _random.nextInt(59) + 1;
          break;
        case 'jam':
          time = _random.nextInt(23) + 1;
          break;
        case 'hari':
          time = _random.nextInt(29) + 1;
          break;
        case 'bulan':
          time = _random.nextInt(11) + 1;
          break;
      }

      final timeString = '$time $timeUnit yang lalu';

      return {
        'name': friend,
        'action': action,
        'time': timeString,
        'avatarUrl': 'https://i.pravatar.cc/150?u=$friend$index',
        'itemUrl': 'https://picsum.photos/seed/${index + 50}/100',
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _notifications.length,
      itemBuilder: (context, index) {
        final notif = _notifications[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(notif['avatarUrl']!),
          ),
          title: Text('${notif['name']!} ${notif['action']!}'),
          subtitle: Text(notif['time']!),
          trailing: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(notif['itemUrl']!),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
}
