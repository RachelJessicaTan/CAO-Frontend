import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:frontend/pages/PlaceDetailPage.dart';

class FolderDetailPage extends StatelessWidget {
  final String folderTitle;
  final List<Map<String, String>> spots;

  const FolderDetailPage({
    super.key,
    required this.folderTitle,
    required this.spots,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: const Icon(Icons.arrow_back, size: 24, color: Colors.black),
                  ),
                ),
                Expanded(
                  child: Text(
                    folderTitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 40),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
              child: Column(
                children: spots.map((spot) => Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _buildSpotCard(context, spot),
                )).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpotCard(BuildContext context, Map<String, String> spot) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PlaceDetailPage(spot: spot)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 12, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  child: Image.network(spot['img']!, height: 180, width: double.infinity, fit: BoxFit.cover),
                ),
                Positioned(
                  top: 12,
                  right: 12,
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
              ],
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