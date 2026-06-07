import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:frontend/models/models.dart';
import 'package:frontend/viewmodels/saved_viewmodel.dart';
import 'package:frontend/views/pages/place_detail_page.dart';

class FolderDetailPage extends StatelessWidget {
  final String folderName;

  const FolderDetailPage({super.key, required this.folderName});

  @override
  Widget build(BuildContext context) {
    return Consumer<SavedViewModel>(
      builder: (context, vm, _) {
        final places = vm.folders[folderName] ?? [];

        return Scaffold(
          backgroundColor: AppColors.white,
          body: Column(
            children: [
              Container(
                color: AppColors.white,
                padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(Icons.arrow_back, size: 24),
                      ),
                    ),
                    Expanded(
                      child: Text(folderName,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
              ),
              Expanded(
                child: places.isEmpty
                    ? Center(
                        child: Text('No places in this folder',
                            style: TextStyle(color: Colors.grey.shade400)))
                    : SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
                        child: Column(
                          children: places
                              .map((place) => Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: _buildCard(context, place, vm),
                                  ))
                              .toList(),
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCard(BuildContext context, PlaceModel place, SavedViewModel vm) {
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => PlaceDetailPage(place: place))),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 12,
                offset: const Offset(0, 4))
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  child: place.coverUrl != null
                      ? Image.network(place.coverUrl!,
                          height: 180, width: double.infinity, fit: BoxFit.cover)
                      : Container(height: 180, color: Colors.grey.shade200),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category badge
                      if (place.primaryCategory.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                              color: AppColors.black,
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(place.primaryCategory,
                              style: const TextStyle(
                                  color: AppColors.brandYellow,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600)),
                        ),
                      Text(place.name,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(place.address,
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 13)),
                      const SizedBox(height: 8),
                      Row(children: [
                        const Icon(PhosphorIconsRegular.chatCircle, size: 15),
                        const SizedBox(width: 4),
                        Text('${place.totalReviews}',
                            style: const TextStyle(fontSize: 13)),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 12,
              right: 12,
              child: GestureDetector(
                onTap: () => _confirmRemove(context, place, vm),
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.15), blurRadius: 4)
                    ],
                  ),
                  child: const Icon(Icons.remove, size: 16, color: AppColors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmRemove(BuildContext context, PlaceModel place, SavedViewModel vm) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Remove', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('Remove "${place.name}" from this folder?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              vm.unsaveFromFolder(place, folderName);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.black,
                foregroundColor: AppColors.brandYellow),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}