import 'dart:typed_data';

import 'package:flutter/material.dart';

class TopSearchBar extends StatelessWidget {
  const TopSearchBar({
    super.key,
    required this.controller,
    required this.profileName,
    this.onChanged,
    this.profileImageBytes,
    this.onProfileTap,
  });

  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final String profileName;
  final Uint8List? profileImageBytes;
  final VoidCallback? onProfileTap;

  String get _initial {
    final trimmed = profileName.trim();
    if (trimmed.isEmpty) {
      return 'M';
    }
    return trimmed[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                decoration: const InputDecoration(
                  hintText: 'Cari ide... (nama atau author)',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          InkWell(
            borderRadius: BorderRadius.circular(40),
            onTap: onProfileTap,
            child: CircleAvatar(
              backgroundColor: Colors.blueAccent,
              backgroundImage: profileImageBytes != null
                  ? MemoryImage(profileImageBytes!)
                  : null,
              child: profileImageBytes == null
                  ? Text(
                      _initial,
                      style: const TextStyle(color: Colors.white),
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
