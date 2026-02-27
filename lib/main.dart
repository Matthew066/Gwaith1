import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'profile_image_picker.dart';

void main() {
  runApp(const PinterestCloneApp());
}

class PinterestCloneApp extends StatelessWidget {
  const PinterestCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gwaith',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const MainLayout(),
    );
  }
}

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;
  String _profileName = 'M';
  Uint8List? _profileImageBytes;
  final List<Map<String, dynamic>> _pins = List.generate(20, (index) => {
    'id': index,
    'url': 'https://picsum.photos/seed/${index + 10}/400/${(index % 4 + 3) * 100}',
    'height': (index % 4 + 3) * 100.0,
    'title': 'Gambar ${index + 1}',
    'author': 'Author ${index % 6 + 1}',
    'description': 'Deskripsi untuk gambar ${index + 1}. Ini contoh teks deskripsi yang lebih panjang.',
  });
  final List<Map<String, dynamic>> _boards = List.generate(3, (index) => {
    'name': 'Board Inspirasi ${index + 1}',
    'pinCount': 12,
    'isPrivate': true,
  });
  int _idCounter = 1000;

  void _addPin({
    required String title,
    required String author,
    required String description,
    required String imageUrl,
    String? boardName,
  }) {
    setState(() {
      _pins.insert(0, {
        'id': _idCounter++,
        'url': imageUrl,
        'height': 260.0,
        'title': title,
        'author': author,
        'description': description,
      });
      if (boardName != null) {
        final index = _boards.indexWhere((board) => board['name'] == boardName);
        if (index != -1) {
          _boards[index]['pinCount'] = (_boards[index]['pinCount'] as int) + 1;
        }
      }
    });
  }

  void _addBoard({
    required String name,
    required bool isPrivate,
  }) {
    setState(() {
      _boards.insert(0, {
        'name': name,
        'pinCount': 0,
        'isPrivate': isPrivate,
      });
    });
  }

  void _addCollage({
    required String title,
    required String theme,
  }) {
    setState(() {
      _pins.insert(0, {
        'id': _idCounter++,
        'url': 'https://picsum.photos/seed/collage_$_idCounter/500/400',
        'height': 320.0,
        'title': 'Kolase: $title',
        'author': 'Anda',
        'description': 'Kolase bertema $theme',
      });
    });
  }

  String get _profileInitial {
    final trimmed = _profileName.trim();
    if (trimmed.isEmpty) return 'M';
    return trimmed[0].toUpperCase();
  }

  Future<void> _pickProfileImage(VoidCallback refreshDialog) async {
    if (!supportsProfileImagePicker) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pilih gambar dari file explorer saat ini tersedia di Flutter Web')),
        );
      }
      return;
    }

    final bytes = await pickProfileImageBytes();
    if (bytes == null) return;

    setState(() {
      _profileImageBytes = bytes;
    });
    refreshDialog();
  }

  Future<void> _showEditProfileDialog() async {
    final nameController = TextEditingController(text: _profileName);
    await showDialog<void>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              title: const Text('Edit Profil'),
              content: SizedBox(
                width: 360,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => _pickProfileImage(() => setDialogState(() {})),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.blueAccent,
                        backgroundImage: _profileImageBytes != null ? MemoryImage(_profileImageBytes!) : null,
                        child: _profileImageBytes == null ? Text(_profileInitial, style: const TextStyle(color: Colors.white, fontSize: 24)) : null,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: () => _pickProfileImage(() => setDialogState(() {})),
                      icon: const Icon(Icons.photo_library_outlined),
                      label: const Text('Pilih gambar dari file explorer'),
                    ),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Nama profil'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Batal'),
                ),
                FilledButton(
                  onPressed: () {
                    setState(() {
                      _profileName = nameController.text.trim().isEmpty ? 'M' : nameController.text.trim();
                    });
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profil diperbarui')));
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeFeedPage(
        items: _pins,
        profileName: _profileName,
        profileImageBytes: _profileImageBytes,
        onProfileTap: _showEditProfileDialog,
      ),
      const CategoriesPage(),
      BoardsPage(boards: _boards),
      CreatePage(
        boardNames: _boards.map((board) => board['name'] as String).toList(),
        onCreatePin: _addPin,
        onCreateBoard: _addBoard,
        onCreateCollage: _addCollage,
      ),
      const NotificationsPage(),
      const MessagesPage(),
    ];
    return Scaffold(
      body: Row(
        children: [
          // Sidebar Navigasi
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.none,
            leading: Column(
              children: [
                const SizedBox(height: 20),
                const Text('Gwaith', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
              ],
            ),
            trailing: Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: IconButton(
                    icon: const Icon(Icons.settings_outlined),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsPage()));
                    },
                  ),
                ),
              ),
            ),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.home_filled),
                selectedIcon: Icon(Icons.home),
                label: Text('Home'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.favorite_border),
                selectedIcon: Icon(Icons.favorite),
                label: Text('Categories'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: Text('Boards'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.add_box_outlined),
                selectedIcon: Icon(Icons.add_box),
                label: Text('Create'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.notifications_outlined),
                selectedIcon: Icon(Icons.notifications),
                label: Text('Notifications'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.chat_bubble_outline),
                selectedIcon: Icon(Icons.chat_bubble),
                label: Text('Messages'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // Area Konten Dinamis
          Expanded(
            child: pages[_selectedIndex],
          ),
        ],
      ),
    );
  }
}

// --- 1. HOME FEED PAGE ---
class HomeFeedPage extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final String profileName;
  final Uint8List? profileImageBytes;
  final VoidCallback onProfileTap;

  const HomeFeedPage({
    super.key,
    required this.items,
    required this.profileName,
    required this.profileImageBytes,
    required this.onProfileTap,
  });

  @override
  State<HomeFeedPage> createState() => _HomeFeedPageState();
}

class _HomeFeedPageState extends State<HomeFeedPage> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  List<Map<String, dynamic>> get _filteredItems {
    if (_query.isEmpty) return widget.items;
    return widget.items.where((it) => (it['title'] as String).toLowerCase().contains(_query.toLowerCase()) || (it['author'] as String).toLowerCase().contains(_query.toLowerCase())).toList();
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
          onChanged: (v) => setState(() => _query = v),
          profileName: widget.profileName,
          profileImageBytes: widget.profileImageBytes,
          onProfileTap: widget.onProfileTap,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: const [
              Text('Semua', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(width: 20),
              Text('Untuk Anda', style: TextStyle(color: Colors.grey, fontSize: 16)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Expanded(child: PinterestMasonryGrid(items: _filteredItems)),
      ],
    );
  }
}

// --- 2. CATEGORIES PAGE (Liked Content) ---
class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _CategorySelectorView();
  }
}

class _CategorySelectorView extends StatefulWidget {
  const _CategorySelectorView();

  @override
  State<_CategorySelectorView> createState() => _CategorySelectorViewState();
}

class _CategorySelectorViewState extends State<_CategorySelectorView> {
  final List<String> _categories = ['Galaxy', 'Architecture', 'Nature', 'UI Design', 'Travel', 'Art'];
  final Set<String> _selected = {};

  void _toggleCategory(String category) {
    setState(() {
      if (_selected.contains(category)) {
        _selected.remove(category);
      } else {
        _selected.add(category);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Kategori & Minat Anda', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Terpilih: ${_selected.length}', style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 2,
              ),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selected.contains(category);
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _toggleCategory(category),
                    child: Ink(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? Colors.red : Colors.transparent,
                          width: 2,
                        ),
                        image: DecorationImage(
                          image: NetworkImage('https://picsum.photos/seed/$category/400/200'),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(Colors.black.withValues(alpha: 0.35), BlendMode.darken),
                        ),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (isSelected) ...[
                              const Icon(Icons.check_circle, color: Colors.white, size: 20),
                              const SizedBox(width: 6),
                            ],
                            Text(
                              category,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// --- 3. BOARDS PAGE ---
class BoardsPage extends StatelessWidget {
  final List<Map<String, dynamic>> boards;
  const BoardsPage({super.key, required this.boards});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Papan Anda (Boards)', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: boards.length,
              itemBuilder: (context, index) {
                final board = boards[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: Container(height: 100, color: Colors.grey[300])),
                          const SizedBox(width: 2),
                          Expanded(
                            child: Column(
                              children: [
                                Container(height: 49, color: Colors.grey[200]),
                                const SizedBox(height: 2),
                                Container(height: 49, color: Colors.grey[100]),
                              ],
                            ),
                          ),
                        ],
                      ),
                      ListTile(
                        title: Text(board['name'] as String),
                        subtitle: Text('${board['pinCount']} Pin'),
                        trailing: Icon(
                          (board['isPrivate'] as bool) ? Icons.lock_outline : Icons.public,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// --- 4. CREATE PAGE ---
class CreatePage extends StatelessWidget {
  final List<String> boardNames;
  final void Function({
    required String title,
    required String author,
    required String description,
    required String imageUrl,
    String? boardName,
  }) onCreatePin;
  final void Function({
    required String name,
    required bool isPrivate,
  }) onCreateBoard;
  final void Function({
    required String title,
    required String theme,
  }) onCreateCollage;

  const CreatePage({
    super.key,
    required this.boardNames,
    required this.onCreatePin,
    required this.onCreateBoard,
    required this.onCreateCollage,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.add_circle_outline, size: 100, color: Colors.grey),
          const SizedBox(height: 20),
          const Text('Buat Sesuatu yang Baru', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 30),
          _createOption(
            context: context,
            icon: Icons.pin_drop,
            label: 'Buat Pin',
            onPressed: () => _showCreatePinDialog(context),
          ),
          _createOption(
            context: context,
            icon: Icons.dashboard_customize,
            label: 'Buat Papan',
            onPressed: () => _showCreateBoardDialog(context),
          ),
          _createOption(
            context: context,
            icon: Icons.auto_awesome_motion,
            label: 'Buat Kolase',
            onPressed: () => _showCreateCollageDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _createOption({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(bottom: 12),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }

  Future<void> _showCreatePinDialog(BuildContext context) async {
    final titleController = TextEditingController();
    final authorController = TextEditingController(text: 'Anda');
    final descriptionController = TextEditingController();
    final imageUrlController = TextEditingController();
    String selectedBoard = boardNames.isNotEmpty ? boardNames.first : '';

    final created = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              title: const Text('Buat Pin'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Judul Pin'),
                    ),
                    TextField(
                      controller: authorController,
                      decoration: const InputDecoration(labelText: 'Nama Pembuat'),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(labelText: 'Deskripsi'),
                      maxLines: 2,
                    ),
                    TextField(
                      controller: imageUrlController,
                      decoration: const InputDecoration(
                        labelText: 'URL Gambar (opsional)',
                        hintText: 'https://...',
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      initialValue: selectedBoard,
                      items: [
                        const DropdownMenuItem<String>(
                          value: '',
                          child: Text('Tanpa papan'),
                        ),
                        ...boardNames.map((name) => DropdownMenuItem<String>(
                          value: name,
                          child: Text(name),
                        )),
                      ],
                      onChanged: (value) {
                        setDialogState(() {
                          selectedBoard = value ?? '';
                        });
                      },
                      decoration: const InputDecoration(labelText: 'Simpan ke papan'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('Batal'),
                ),
                FilledButton(
                  onPressed: () {
                    final title = titleController.text.trim();
                    if (title.isEmpty) return;
                    final generatedImage = 'https://picsum.photos/seed/pin_${DateTime.now().millisecondsSinceEpoch}/500/700';
                    onCreatePin(
                      title: title,
                      author: authorController.text.trim().isEmpty ? 'Anda' : authorController.text.trim(),
                      description: descriptionController.text.trim(),
                      imageUrl: imageUrlController.text.trim().isEmpty ? generatedImage : imageUrlController.text.trim(),
                      boardName: selectedBoard.isEmpty ? null : selectedBoard,
                    );
                    Navigator.pop(ctx, true);
                  },
                  child: const Text('Simpan Pin'),
                ),
              ],
            );
          },
        );
      },
    );

    if (created == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pin berhasil dibuat')));
    }
  }

  Future<void> _showCreateBoardDialog(BuildContext context) async {
    final nameController = TextEditingController();
    bool isPrivate = true;

    final created = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              title: const Text('Buat Papan'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Nama papan'),
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    value: isPrivate,
                    title: const Text('Papan privat'),
                    onChanged: (v) => setDialogState(() => isPrivate = v),
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('Batal'),
                ),
                FilledButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    if (name.isEmpty) return;
                    onCreateBoard(name: name, isPrivate: isPrivate);
                    Navigator.pop(ctx, true);
                  },
                  child: const Text('Simpan Papan'),
                ),
              ],
            );
          },
        );
      },
    );

    if (created == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Papan berhasil dibuat')));
    }
  }

  Future<void> _showCreateCollageDialog(BuildContext context) async {
    final titleController = TextEditingController();
    final themeController = TextEditingController(text: 'Inspirasi');

    final created = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Buat Kolase'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Judul kolase'),
            ),
            TextField(
              controller: themeController,
              decoration: const InputDecoration(labelText: 'Tema kolase'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              final title = titleController.text.trim();
              if (title.isEmpty) return;
              onCreateCollage(
                title: title,
                theme: themeController.text.trim().isEmpty ? 'Inspirasi' : themeController.text.trim(),
              );
              Navigator.pop(ctx, true);
            },
            child: const Text('Simpan Kolase'),
          ),
        ],
      ),
    );

    if (created == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Kolase berhasil dibuat')));
    }
  }
}

// --- 5. NOTIFICATIONS PAGE ---
class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const CircleAvatar(backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=user')),
          title: Text('User $index menyukai Pin Anda'),
          subtitle: const Text('2 jam yang lalu'),
          trailing: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: const DecorationImage(image: NetworkImage('https://picsum.photos/100'), fit: BoxFit.cover),
            ),
          ),
        );
      },
    );
  }
}

// --- 6. MESSAGES PAGE ---
class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> friends = List.generate(6, (i) => 'Teman ${i + 1}');
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Pesan', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: friends.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text(friends[index]),
                subtitle: const Text('Terakhir: Halo!'),
                trailing: const Text('14:30'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => ChatPage(name: friends[index])));
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

// --- KOMPONEN PENDUKUNG ---

class TopSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final String profileName;
  final Uint8List? profileImageBytes;
  final VoidCallback? onProfileTap;

  const TopSearchBar({
    super.key,
    required this.controller,
    this.onChanged,
    required this.profileName,
    this.profileImageBytes,
    this.onProfileTap,
  });

  String get _initial {
    final trimmed = profileName.trim();
    if (trimmed.isEmpty) return 'M';
    return trimmed[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
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
              backgroundImage: profileImageBytes != null ? MemoryImage(profileImageBytes!) : null,
              child: profileImageBytes == null ? Text(_initial, style: const TextStyle(color: Colors.white)) : null,
            ),
          ),
        ],
      ),
    );
  }
}

class PinterestMasonryGrid extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  const PinterestMasonryGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: SingleChildScrollView(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: items.asMap().entries.where((e) => e.key % 2 == 0).map((e) => _buildGridItem(context, e.value)).toList(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                children: items.asMap().entries.where((e) => e.key % 2 != 0).map((e) => _buildGridItem(context, e.value)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => ImageDetailPage(item: item)));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Image.network(item['url'], height: item['height'], width: double.infinity, fit: BoxFit.cover),
              Positioned(
                left: 8,
                bottom: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.45), borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['title'] ?? '', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      Text(item['author'] ?? '', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageDetailPage extends StatelessWidget {
  final Map<String, dynamic> item;
  const ImageDetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item['title'] ?? 'Detail')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(item['url'], fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['title'] ?? '', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('By ${item['author'] ?? '-'}', style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 12),
                  Text(item['description'] ?? ''),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: ListView(
        children: [
          SwitchListTile(title: const Text('Notifikasi'), value: true, onChanged: (_) {}),
          ListTile(title: const Text('Akun'), subtitle: const Text('Kelola akun Anda'), onTap: () {}),
          ListTile(title: const Text('Bantuan'), onTap: () {}),
        ],
      ),
    );
  }
}

class ChatPage extends StatefulWidget {
  final String name;
  const ChatPage({super.key, required this.name});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add({'from': 'me', 'text': text});
    });
    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.name)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final m = _messages[index];
                final isMe = m['from'] == 'me';
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: isMe ? Colors.blueAccent : Colors.grey[300], borderRadius: BorderRadius.circular(8)),
                    child: Text(m['text'] ?? '', style: TextStyle(color: isMe ? Colors.white : Colors.black87)),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(controller: _controller, decoration: const InputDecoration(hintText: 'Ketik pesan...')),
                  ),
                  IconButton(icon: const Icon(Icons.send), onPressed: _send),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
