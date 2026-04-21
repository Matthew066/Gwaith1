import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../profile_image_picker.dart';
import '../screens/boards_page.dart';
import '../screens/categories_page.dart';
import '../screens/create_page.dart';
import '../screens/home_feed_page.dart';
import '../screens/messages_page.dart';
import '../screens/notifications_page.dart';
import '../screens/settings_page.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  static const String _gwaithLogoAsset = 'assets/images/logogwaith.png';
  int _selectedIndex = 0;
  String _profileName = 'M';
  Uint8List? _profileImageBytes;
  final Set<int> _likedPinIds = <int>{};
  final List<String> _friendNames = [
    'Calvin',
    'Ello',
    'Theo',
    'Wellsi',
    'Bagas',
    'Putra',
  ];
  late final Map<String, List<Map<String, String>>> _directMessages;

  final List<String> _allCategories = [
    'Galaxy',
    'Architecture',
    'Nature',
    'UI Design',
    'Travel',
    'Art',
  ];

  final List<Map<String, String>> _initialPinDetails = [
    {
      'title': 'Serigala',
      'author': 'Calvin',
      'description': 'Serigala berjalan di hutan yang tenang.',
    },
    {
      'title': 'Theo menikmati senja',
      'author': 'Theo',
      'description': 'Theo duduk santai menikmati cahaya senja di tepi kota.',
    },
    {
      'title': 'Pohon palem di pantai',
      'author': 'Ello',
      'description': 'Pohon palem tinggi memberi suasana liburan yang hangat.',
    },
    {
      'title': 'Cahaya pagi di padang',
      'author': 'Wellsi',
      'description': 'Sinar matahari pagi menyinari padang rumput luas.',
    },
    {
      'title': 'Langit galaxy',
      'author': 'Bagas',
      'description': 'Inspirasi warna galaxy untuk suasana yang dramatis.',
    },
    {
      'title': 'Putra di jalan kota',
      'author': 'Putra',
      'description': 'Momen jalan kota yang terlihat sederhana dan estetik.',
    },
    {
      'title': 'Rumah minimalis',
      'author': 'Calvin',
      'description': 'Ide rumah minimalis dengan bentuk yang bersih.',
    },
    {
      'title': 'Sketsa ruang kerja',
      'author': 'Ello',
      'description': 'Referensi ruang kerja rapi untuk fokus berkarya.',
    },
    {
      'title': 'Taman sore hari',
      'author': 'Theo',
      'description': 'Taman hijau dengan suasana sore yang kalem.',
    },
    {
      'title': 'Kopi dan catatan',
      'author': 'Wellsi',
      'description': 'Meja kecil dengan kopi dan catatan ide harian.',
    },
    {
      'title': 'Pegunungan berkabut',
      'author': 'Bagas',
      'description': 'Pemandangan gunung berkabut yang terasa sejuk.',
    },
    {
      'title': 'Lampu jalan malam',
      'author': 'Putra',
      'description': 'Lampu jalan memberi nuansa malam yang sinematik.',
    },
    {
      'title': 'Ilustrasi karakter',
      'author': 'Calvin',
      'description': 'Inspirasi karakter dengan gaya ilustrasi modern.',
    },
    {
      'title': 'Pantai biru',
      'author': 'Ello',
      'description': 'Air laut biru dengan suasana pantai yang bersih.',
    },
    {
      'title': 'Gedung kaca',
      'author': 'Theo',
      'description': 'Arsitektur gedung kaca dengan refleksi langit.',
    },
    {
      'title': 'Bunga merah',
      'author': 'Wellsi',
      'description': 'Detail bunga merah yang cocok untuk moodboard warna.',
    },
    {
      'title': 'Motor klasik',
      'author': 'Bagas',
      'description': 'Motor klasik dengan nuansa retro yang kuat.',
    },
    {
      'title': 'Jembatan kota',
      'author': 'Putra',
      'description': 'Jembatan kota sebagai inspirasi foto urban.',
    },
    {
      'title': 'Kucing di jendela',
      'author': 'Calvin',
      'description': 'Kucing duduk tenang di dekat jendela rumah.',
    },
    {
      'title': 'Senja di danau',
      'author': 'Ello',
      'description': 'Pantulan senja di danau yang terlihat damai.',
    },
  ];

  final _authors = [
    'Oda',
    'Masashi Kishimoto',
    'Elon Musk',
    'Bill gates',
    'Deddy Corbuzier',
    'YB',
  ];

  Set<String> _selectedCategories = {};
  late List<Map<String, dynamic>> _pins;
  late List<Map<String, dynamic>> _boards;
  int _idCounter = 1000;

  @override
  void initState() {
    super.initState();

    _directMessages = {
      for (final friend in _friendNames) friend: <Map<String, String>>[],
    };

    _boards = List.generate(
      3,
      (index) => {
        'name': 'Board Inspirasi ${index + 1}',
        'pinCount': 0,
        'isPrivate': true,
        'pins': <Map<String, dynamic>>[],
      },
    );

    _pins = List.generate(20, (index) {
      final detail = _initialPinDetails[index];
      final category = _allCategories[index % _allCategories.length];
      final author = _authors[index % _authors.length];
      final boardName = _boards[index % _boards.length]['name'] as String;
      return {
        'id': index,
        'url':
            'https://picsum.photos/seed/${index + 10}/400/${(index % 4 + 3) * 100}',
        'height': (index % 4 + 3) * 100.0,
        'title': 'Gambar ${index + 1}',
        'author': 'Author ${index % 6 + 1}',
        'description': 'Deskripsi untuk gambar ${index + 1}. Ini contoh teks deskripsi yang lebih panjang.',
        'category': category,
        'boardName': boardName,
      };
    });

    for (final pin in _pins) {
      final name = pin['boardName'] as String?;
      if (name == null) {
        continue;
      }

      final board = _boards.firstWhere((item) => item['name'] == name);
      (board['pins'] as List).add(pin);
      board['pinCount'] = (board['pinCount'] as int) + 1;
    }
  }

  void _addPin({
    required String title,
    required String author,
    required String description,
    required String imageUrl,
    String? boardName,
  }) {
    setState(() {
      final category = _selectedCategories.isNotEmpty
          ? _selectedCategories.first
          : (_allCategories.toList()..shuffle()).first;

      final pin = {
        'id': _idCounter++,
        'url': imageUrl,
        'height': 260.0,
        'title': title,
        'author': author,
        'description': description,
        'category': category,
        'boardName': boardName,
      };

      _pins.insert(0, pin);

      if (boardName == null || boardName.isEmpty) {
        return;
      }

      final boardIndex = _boards.indexWhere(
        (board) => board['name'] == boardName,
      );
      if (boardIndex == -1) {
        return;
      }

      final board = _boards[boardIndex];
      board['pinCount'] = (board['pinCount'] as int) + 1;
      (board['pins'] as List).insert(0, pin);
    });
  }

  void _addBoard({required String name, required bool isPrivate}) {
    setState(() {
      _boards.insert(0, {
        'name': name,
        'pinCount': 0,
        'isPrivate': isPrivate,
        'pins': <Map<String, dynamic>>[],
      });
    });
  }

  void _addCollage({required String title, required String theme}) {
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

  void _sendDirectMessage(String friendName, Map<String, String> message) {
    setState(() {
      _directMessages.putIfAbsent(friendName, () => <Map<String, String>>[]).add(message);
    });
  }

  void _sendPinToDm(String friendName, Map<String, dynamic> pin) {
    _sendDirectMessage(friendName, {
      'from': 'me',
      'type': 'pin',
      'title': pin['title'] as String? ?? 'Pin Gwaith',
      'imageUrl': pin['url'] as String? ?? '',
      'text': 'Aku kirim pin ini ke kamu',
    });
  }

  String get _profileInitial {
    final trimmed = _profileName.trim();
    if (trimmed.isEmpty) {
      return 'M';
    }
    return trimmed[0].toUpperCase();
  }

  Future<void> _pickProfileImage(VoidCallback refreshDialog) async {
    if (!supportsProfileImagePicker) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Pilih gambar dari file explorer saat ini tersedia di Flutter Web',
            ),
          ),
        );
      }
      return;
    }

    final bytes = await pickProfileImageBytes();
    if (bytes == null) {
      return;
    }

    setState(() {
      _profileImageBytes = bytes;
    });
    refreshDialog();
  }

  Future<void> _showEditProfileDialog() async {
    final nameController = TextEditingController(text: _profileName);

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              title: const Text('Edit Profil'),
              content: SizedBox(
                width: 360,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () =>
                          _pickProfileImage(() => setDialogState(() {})),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.blueAccent,
                        backgroundImage: _profileImageBytes != null
                            ? MemoryImage(_profileImageBytes!)
                            : null,
                        child: _profileImageBytes == null
                            ? Text(
                                _profileInitial,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                ),
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: () =>
                          _pickProfileImage(() => setDialogState(() {})),
                      icon: const Icon(Icons.photo_library_outlined),
                      label: const Text('Pilih gambar dari file explorer'),
                    ),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nama profil',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Batal'),
                ),
                FilledButton(
                  onPressed: () {
                    setState(() {
                      _profileName = nameController.text.trim().isEmpty
                          ? 'M'
                          : nameController.text.trim();
                    });
                    Navigator.pop(dialogContext);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profil diperbarui')),
                    );
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
    final forYouItems = _pins.where((pin) {
      final pinId = pin['id'] as int?;
      final category = pin['category'] as String?;
      final matchesLike = pinId != null && _likedPinIds.contains(pinId);
      final matchesCategory =
          category != null && _selectedCategories.contains(category);
      return matchesLike || matchesCategory;
    }).toList();

    final pages = [
      HomeFeedPage(
        items: _pins,
        forYouItems: forYouItems,
        profileName: _profileName,
        profileImageBytes: _profileImageBytes,
        onProfileTap: _showEditProfileDialog,
        selectedCategories: _selectedCategories,
        likedPinIds: _likedPinIds,
        friendNames: _friendNames,
        onSendPinToDm: _sendPinToDm,
        onToggleLike: (pinId) {
          setState(() {
            if (_likedPinIds.contains(pinId)) {
              _likedPinIds.remove(pinId);
            } else {
              _likedPinIds.add(pinId);
            }
          });
        },
      ),
      CategoriesPage(
        categories: _allCategories,
        selected: _selectedCategories,
        onToggle: (category) {
          setState(() {
            if (_selectedCategories.contains(category)) {
              _selectedCategories.remove(category);
            } else {
              _selectedCategories.add(category);
            }
          });
        },
      ),
      BoardsPage(boards: _boards, onAddBoard: _addBoard),
      CreatePage(
        boardNames: _boards.map((board) => board['name'] as String).toList(),
        onCreatePin: _addPin,
        onCreateBoard: _addBoard,
        onCreateCollage: _addCollage,
      ),
      const NotificationsPage(),
      MessagesPage(
        friends: _friendNames,
        directMessages: _directMessages,
        onSendMessage: _sendDirectMessage,
      ),
    ];

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.none,
            leading: Column(
              children: [
                const SizedBox(height: 20),
                Image.asset(
                  _gwaithLogoAsset,
                  width: 92,
                  height: 44,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Text(
                      'Gwaith',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
            trailing: Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: IconButton(
                    icon: const Icon(Icons.settings_outlined),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const SettingsPage()),
                      );
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
          Expanded(child: pages[_selectedIndex]),
        ],
      ),
    );
  }
}
