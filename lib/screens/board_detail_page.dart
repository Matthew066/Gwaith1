import 'package:flutter/material.dart';

import '../widgets/pinterest_masonry_grid.dart';

class BoardDetailPage extends StatelessWidget {
  const BoardDetailPage({
    super.key,
    required this.name,
    required this.pins,
  });

  final String name;
  final List<Map<String, dynamic>> pins;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.red,
      ),
      body: PinterestMasonryGrid(items: pins),
    );
  }
}
