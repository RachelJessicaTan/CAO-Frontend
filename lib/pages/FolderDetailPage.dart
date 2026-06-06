import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:frontend/pages/PlaceDetailPage.dart';

class FolderDetailPage extends StatefulWidget {
  final String folderTitle;
  final List<Map<String, String>> spots;

  const FolderDetailPage({
    super.key,
    required this.folderTitle,
    required this.spots,
  });

  @override
  State<FolderDetailPage> createState() => _FolderDetailPageState();
}

class _FolderDetailPageState extends State<FolderDetailPage> {
  late List<Map<String, String>> _currentSpots;

  @override
  void initState() {
    super.initState();
    _currentSpots = List.from(widget.spots);
  }

  // FIXED TYPE: Dibuat generic <T> agar serasi dengan SavedPlacesPage
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

  void _showDeleteDialog(int index, String spotName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
          title: const Text('Remove Spot', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          content: Text('Do you really want to remove "$spotName" from this folder?', style: const TextStyle(fontSize: 14)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _currentSpots.removeAt(index);
                });
                Navigator.pop(context);
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Spot removed from folder'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              child: const Text('Remove', style: TextStyle(color: Color(0xFFFCDD3F), fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
            child: Row(
              children: [
                GestureDetector(
                  // Tetap mengirimkan status data _currentSpots terbaru ke SavedPlacesPage saat back
                  onTap: () => Navigator.pop(context, _currentSpots),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: const Icon(Icons.arrow_back, size: 24, color: Colors.black),
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.folderTitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 40), 
              ],
            ),
          ),
          
          // List Spots
          Expanded(
            child: _currentSpots.isEmpty
                ? Center(
                    child: Text(
                      'No spots saved in this folder yet.',
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
                    child: Column(
                      children: List.generate(_currentSpots.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: _buildSpotCard(context, _currentSpots[index], index),
                        );
                      }),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpotCard(BuildContext context, Map<String, String> spot, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Stack(
        children: [
          // LAYER 1: Detektor Klik Navigasi Utama ke Detail Tempat
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  _createSmoothRoute(PlaceDetailPage(spot: spot)),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ),

          // LAYER 2: Tampilan Visual (Gambar & Informasi) - Dibungkus IgnorePointer agar klik tembus ke Layer 1
          IgnorePointer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  child: Image.network(
                    spot['img']!, 
                    height: 180, 
                    width: double.infinity, 
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 180,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.broken_image, size: 40, color: Colors.grey),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(spot['title']!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(spot['loc']!, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(PhosphorIconsRegular.chatCircle, size: 15),
                              const SizedBox(width: 4),
                              Text(spot['count']!, style: const TextStyle(fontSize: 13)),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          _buildSmallTag(PhosphorIconsRegular.shoppingBag),
                          const SizedBox(width: 8),
                          _buildSmallTag(PhosphorIconsRegular.forkKnife),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // LAYER 3: Tombol Minus Absolut (Di atas IgnorePointer agar kliknya mandiri)
          Positioned(
            top: 12,
            right: 12,
            child: InkWell(
              onTap: () => _showDeleteDialog(index, spot['title']!),
              customBorder: const CircleBorder(),
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
        ],
      ),
    );
  }

  Widget _buildSmallTag(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
      child: Icon(icon, color: const Color(0xFFFCDD3F), size: 16),
    );
  }
}