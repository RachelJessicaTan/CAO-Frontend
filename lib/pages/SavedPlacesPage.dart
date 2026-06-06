import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:frontend/pages/SearchPage.dart';
import 'package:frontend/pages/AddPlacePage.dart';
import 'package:frontend/pages/FolderDetailPage.dart';

class SavedPlacesPage extends StatefulWidget {
  const SavedPlacesPage({super.key});

  @override
  State<SavedPlacesPage> createState() => _SavedPlacesPageState();
}

class _SavedPlacesPageState extends State<SavedPlacesPage> {
  int _currentNavIndex = 4;

  final List<Map<String, dynamic>> savedFolders = [
    {
      'title': 'Night Out',
      'description': 'I made this folder for my night out with friends :)',
      'images': [
        'https://images.unsplash.com/photo-1554118811-1e0d58224f24?q=80&w=400&auto=format&fit=crop',
        'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?q=80&w=400&auto=format&fit=crop',
        'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?q=80&w=400&auto=format&fit=crop',
        'https://images.unsplash.com/photo-1559329007-40df8a9345d8?q=80&w=400&auto=format&fit=crop',
      ],
      'spots': [
        {'title': 'The Post', 'loc': 'Cipete, Jakarta Selatan', 'count': '517', 'img': 'https://images.unsplash.com/photo-1554118811-1e0d58224f24?q=80&w=1000&auto=format&fit=crop'},
        {'title': 'Sudestada', 'loc': 'Jl. Irian, Jakarta Pusat', 'count': '842', 'img': 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?q=80&w=1000&auto=format&fit=crop'},
        {'title': 'Fogo de Chão', 'loc': 'SCBD, Jakarta Selatan', 'count': '391', 'img': 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?q=80&w=1000&auto=format&fit=crop'},
      ],
    },
    {
      'title': 'Night Out',
      'description': 'I made this folder for my night out with friends :)',
      'images': [
        'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?q=80&w=400&auto=format&fit=crop',
        'https://images.unsplash.com/photo-1554118811-1e0d58224f24?q=80&w=400&auto=format&fit=crop',
        'https://images.unsplash.com/photo-1559329007-40df8a9345d8?q=80&w=400&auto=format&fit=crop',
        'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?q=80&w=400&auto=format&fit=crop',
      ],
      'spots': [
        {'title': 'Sudestada', 'loc': 'Jl. Irian, Jakarta Pusat', 'count': '842', 'img': 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?q=80&w=1000&auto=format&fit=crop'},
        {'title': 'The Post', 'loc': 'Cipete, Jakarta Selatan', 'count': '517', 'img': 'https://images.unsplash.com/photo-1554118811-1e0d58224f24?q=80&w=1000&auto=format&fit=crop'},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    const Color brandYellow = Color(0xFFFCDD3F);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(32, 60, 32, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset('lib/assets/cao_logo.png', height: 30, fit: BoxFit.contain),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                      child: const Icon(PhosphorIconsRegular.user, color: Colors.white, size: 24),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 120),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 20, offset: const Offset(0, 4)),
                      ],
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text('Saved Places', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 24),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.68,
                          ),
                          itemCount: savedFolders.length,
                          itemBuilder: (context, index) {
                            return _buildFolderCard(context, savedFolders[index]);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 30,
            left: 32,
            right: 32,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: brandYellow,
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 20, offset: const Offset(0, 10)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(0, PhosphorIconsRegular.house),
                  _buildNavItem(1, PhosphorIconsRegular.magnifyingGlass),
                  _buildNavItem(2, PhosphorIconsRegular.plus),
                  _buildNavItem(3, PhosphorIconsRegular.bell),
                  _buildNavItem(4, PhosphorIconsRegular.bookmarkSimple),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFolderCard(BuildContext context, Map<String, dynamic> folder) {
    final List<String> images = List<String>.from(folder['images']);
    final List<Map<String, String>> spots =
        (folder['spots'] as List).map((s) => Map<String, String>.from(s)).toList();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FolderDetailPage(
              folderTitle: folder['title'],
              spots: spots,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 12, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Stack(
                children: [
                  Column(
                    children: [
                      Row(
                        children: images.take(2).map((img) =>
                          Expanded(child: Image.network(img, height: 60, fit: BoxFit.cover))
                        ).toList(),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: images.skip(2).take(2).map((img) =>
                          Expanded(child: Image.network(img, height: 60, fit: BoxFit.cover))
                        ).toList(),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 4),
                        ],
                      ),
                      child: const Icon(Icons.remove, size: 14, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(folder['title'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(
                    folder['description'],
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade500, height: 1.3),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon) {
    final bool isActive = _currentNavIndex == index;
    return GestureDetector(
      onTap: () {
        if (index == 0) {
          Navigator.popUntil(context, (route) => route.isFirst);
          return;
        }
        if (index == 1) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SearchPage()));
          return;
        }
        if (index == 2) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AddPlacePage()));
          return;
        }
        setState(() => _currentNavIndex = index);
      },
      child: AnimatedScale(
        scale: isActive ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.all(isActive ? 12 : 8),
          decoration: BoxDecoration(
            color: isActive ? Colors.black : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isActive ? const Color(0xFFFCDD3F) : Colors.black,
            size: isActive ? 26 : 28,
          ),
        ),
      ),
    );
  }
}