import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Notifikasi'),
            value: true,
            onChanged: (_) {},
          ),
          ListTile(
            title: const Text('Akun'),
            subtitle: const Text('Kelola akun Anda'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Bantuan'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
