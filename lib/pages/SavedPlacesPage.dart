import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:frontend/pages/SearchPage.dart';
import 'package:frontend/pages/AddPlacePage.dart';
import 'package:frontend/pages/NotificationPage.dart';
import 'package:frontend/pages/HomePage.dart';
import 'package:frontend/pages/FolderDetailPage.dart';

class SavedPlacesPage extends StatefulWidget {
  const SavedPlacesPage({super.key});

  @override
  State<SavedPlacesPage> createState() => _SavedPlacesPageState();
}

class _SavedPlacesPageState extends State<SavedPlacesPage> {
  int _currentNavIndex = 4;

  // LINK FIXED: Menggunakan gambar Unsplash yang valid (bebas 404)
  List<Map<String, dynamic>> folders = [
    {
      'title': 'Night Out',
      'desc': 'I made this folder for my night out with friends :)',
      'spots': [
        {'img': 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?q=80&w=600&auto=format&fit=crop', 'title': 'Spot A', 'loc': 'Jakarta', 'count': '12'},
        {'img': 'https://images.unsplash.com/photo-1514933651103-005eec06c04b?q=80&w=600&auto=format&fit=crop', 'title': 'Spot B', 'loc': 'Tangerang', 'count': '8'},
        {'img': 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?q=80&w=600&auto=format&fit=crop', 'title': 'Spot C', 'loc': 'Bandung', 'count': '5'},
        {'img': 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?q=80&w=600&auto=format&fit=crop', 'title': 'Spot D', 'loc': 'Surabaya', 'count': '20'},
      ]
    },
    {
      'title': 'Cafe Hunting',
      'desc': 'Aesthetic cafes near Gading Serpong.',
      'spots': [
        {'img': 'https://images.unsplash.com/photo-1554118811-1e0d58224f24?q=80&w=600&auto=format&fit=crop', 'title': 'Cafe A', 'loc': 'Tangerang', 'count': '15'},
        {'img': 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?q=80&w=600&auto=format&fit=crop', 'title': 'Cafe B', 'loc': 'Jakarta', 'count': '22'},
        {'img': 'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?q=80&w=600&auto=format&fit=crop', 'title': 'Cafe C', 'loc': 'Tangerang', 'count': '7'},
        {'img': 'https://images.unsplash.com/photo-1511920170033-f8396924c348?q=80&w=600&auto=format&fit=crop', 'title': 'Cafe D', 'loc': 'Jakarta', 'count': '10'},
      ]
    }
  ];

  // FIXED TYPE: Menambahkan parameter generic <T> agar cocok dengan ekspektasi Navigator.push
  Route<T> _createSmoothRoute<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 0.02),
              end: Offset.zero,
            ).animate(curvedAnimation),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
    );
  }

  void _showDeleteDialog(int index, String folderName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
          title: const Text('Delete Folder', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          content: Text('Do you really want to delete "$folderName" folder?', style: const TextStyle(fontSize: 14)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  folders.removeAt(index);
                });
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              child: const Text('Delete', style: TextStyle(color: Color(0xFFFCDD3F), fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

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
                          itemCount: folders.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.75,
                          ),
                          itemBuilder: (context, index) {
                            final folder = folders[index];
                            List<dynamic> spots = folder['spots'];

                            return GestureDetector(
                              onTap: () async {
                                List<Map<String, String>> typedSpots = spots.map((spot) {
                                  return Map<String, String>.from(spot as Map);
                                }).toList();

                                // Pemanggilan menggunakan fungsi kustom generic yang baru
                                final updatedSpots = await Navigator.push<List<Map<String, String>>>(
                                  context,
                                  _createSmoothRoute<List<Map<String, String>>>(FolderDetailPage(
                                    folderTitle: folder['title'],
                                    spots: typedSpots,
                                  )),
                                );

                                if (updatedSpots != null) {
                                  setState(() {
                                    folders[index]['spots'] = updatedSpots;
                                  });
                                }
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(24),
                                          child: GridView.count(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 2,
                                            mainAxisSpacing: 2,
                                            physics: const NeverScrollableScrollPhysics(),
                                            children: List.generate(4, (i) {
                                              if (spots.isEmpty) {
                                                return Container(
                                                  color: Colors.grey.shade200,
                                                  child: const Icon(Icons.image_not_supported, size: 20, color: Colors.grey),
                                                );
                                              }
                                              return Image.network(
                                                spots[i % spots.length]['img'],
                                                fit: BoxFit.cover,
                                                loadingBuilder: (context, child, loadingProgress) {
                                                  if (loadingProgress == null) return child;
                                                  return Container(color: Colors.grey.shade100);
                                                },
                                                errorBuilder: (context, error, stackTrace) {
                                                  return Container(
                                                    color: Colors.grey.shade200,
                                                    child: const Icon(Icons.broken_image, size: 20, color: Colors.grey),
                                                  );
                                                },
                                              );
                                            }),
                                          ),
                                        ),
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            onTap: () {},
                                            child: Padding(
                                              padding: const EdgeInsets.all(12.0),
                                              child: GestureDetector(
                                                onTap: () => _showDeleteDialog(index, folder['title']),
                                                child: Container(
                                                  width: 28,
                                                  height: 28,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.circle,
                                                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 4)],
                                                  ),
                                                  child: const Icon(Icons.remove, size: 16, color: Colors.black),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    folder['title'],
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    folder['desc'],
                                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            );
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

  Widget _buildNavItem(int index, IconData icon) {
    final bool isActive = _currentNavIndex == index;
    return GestureDetector(
      onTap: () {
        if (icon == PhosphorIconsRegular.bookmarkSimple) return;

        if (icon == PhosphorIconsRegular.house) {
          Navigator.pushAndRemoveUntil(context, _createSmoothRoute(const HomePage()), (route) => false);
        } else if (icon == PhosphorIconsRegular.magnifyingGlass) {
          Navigator.pushAndRemoveUntil(context, _createSmoothRoute(const SearchPage()), (route) => false);
        } else if (icon == PhosphorIconsRegular.plus) {
          Navigator.pushAndRemoveUntil(context, _createSmoothRoute(const AddPlacePage()), (route) => false);
        } else if (icon == PhosphorIconsRegular.bell) {
          Navigator.pushAndRemoveUntil(context, _createSmoothRoute(const NotificationPage()), (route) => false);
        }
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