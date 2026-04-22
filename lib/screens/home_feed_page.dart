import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../widgets/pinterest_masonry_grid.dart';
import '../widgets/top_search_bar.dart';

class HomeFeedPage extends StatefulWidget {
  const HomeFeedPage({
    super.key,
    required this.items,
    required this.forYouItems,
    required this.profileName,
    required this.profileImageBytes,
    required this.onProfileTap,
    required this.selectedCategories,
    required this.likedPinIds,
    required this.onToggleLike,
    required this.friendNames,
    required this.boardNames,
    required this.onSendPinToDm,
    required this.onSavePinToBoard,
  });

  final List<Map<String, dynamic>> items;
  final List<Map<String, dynamic>> forYouItems;
  final String profileName;
  final Uint8List? profileImageBytes;
  final VoidCallback onProfileTap;
  final Set<String> selectedCategories;
  final Set<int> likedPinIds;
  final ValueChanged<int> onToggleLike;
  final List<String> friendNames;
  final List<String> boardNames;
  final void Function(String friendName, Map<String, dynamic> pin)
  onSendPinToDm;
  final String Function(Map<String, dynamic> pin, String boardName)
  onSavePinToBoard;

  @override
  State<HomeFeedPage> createState() => _HomeFeedPageState();
}

class _HomeFeedPageState extends State<HomeFeedPage> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  bool _forYou = false;

  List<Map<String, dynamic>> get _filteredItems {
    final results = _forYou ? widget.forYouItems : widget.items;

    if (_query.isEmpty) {
      return results;
    }

    final normalizedQuery = _query.toLowerCase();
    return results.where((item) {
      final title = (item['title'] as String).toLowerCase();
      final author = (item['author'] as String).toLowerCase();
      return title.contains(normalizedQuery) ||
          author.contains(normalizedQuery);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TopSearchBar(
          controller: _searchController,
          onChanged: (value) => setState(() => _query = value),
          profileName: widget.profileName,
          profileImageBytes: widget.profileImageBytes,
          onProfileTap: widget.onProfileTap,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => setState(() => _forYou = false),
                child: Text(
                  'Semua',
                  style: TextStyle(
                    fontWeight: !_forYou ? FontWeight.bold : FontWeight.normal,
                    color: !_forYou ? Colors.black : Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              GestureDetector(
                onTap: () => setState(() => _forYou = true),
                child: Text(
                  'Untuk Anda',
                  style: TextStyle(
                    fontWeight: _forYou ? FontWeight.bold : FontWeight.normal,
                    color: _forYou ? Colors.black : Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_forYou &&
            widget.likedPinIds.isEmpty &&
            widget.selectedCategories.isEmpty)
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              'Like pin atau pilih kategori terlebih dahulu',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        const SizedBox(height: 16),
        Expanded(
          child: _filteredItems.isEmpty
              ? Center(
                  child: Text(
                    _forYou
                        ? 'Belum ada rekomendasi. Coba pilih kategori atau like beberapa pin.'
                        : 'Belum ada pin untuk ditampilkan.',
                    style: const TextStyle(color: Colors.black54),
                  ),
                )
              : PinterestMasonryGrid(
                  items: _filteredItems,
                  likedPinIds: widget.likedPinIds,
                  onToggleLike: widget.onToggleLike,
                  friendNames: widget.friendNames,
                  boardNames: widget.boardNames,
                  onSendPinToDm: widget.onSendPinToDm,
                  onSavePinToBoard: widget.onSavePinToBoard,
                ),
        ),
      ],
    );
  }
}
