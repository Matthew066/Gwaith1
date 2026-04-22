import 'package:flutter/material.dart';

import '../widgets/pinterest_masonry_grid.dart';

class BoardDetailPage extends StatelessWidget {
  const BoardDetailPage({
    super.key,
    required this.name,
    required this.pins,
    required this.boardNames,
    required this.onSavePinToBoard,
  });

  final String name;
  final List<Map<String, dynamic>> pins;
  final List<String> boardNames;
  final String Function(Map<String, dynamic> pin, String boardName)
  onSavePinToBoard;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name), backgroundColor: Colors.red),
      body: PinterestMasonryGrid(
        items: pins,
        boardNames: boardNames,
        onSavePinToBoard: onSavePinToBoard,
      ),
    );
  }
}
