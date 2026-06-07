import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:frontend/viewmodels/saved_viewmodel.dart';
import 'package:frontend/views/widgets/bottom_nav_bar.dart';
import 'package:frontend/views/pages/folder_detail_page.dart';
import 'package:frontend/views/pages/profile_page.dart';

class SavedPlacesPage extends StatefulWidget {
  const SavedPlacesPage({super.key});

  @override
  State<SavedPlacesPage> createState() => _SavedPlacesPageState();
}

class _SavedPlacesPageState extends State<SavedPlacesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SavedViewModel>().loadSaved();
    });
  }

  void _showAddFolderDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('New Folder', style: TextStyle(fontWeight: FontWeight.bold)),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Folder name'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                context.read<SavedViewModel>().addFolder(name);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.black, foregroundColor: AppColors.brandYellow),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showDeleteFolderDialog(String name) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Folder', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('Delete "$name" and all its saved places?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              context.read<SavedViewModel>().deleteFolder(name);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: AppColors.white),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SavedViewModel>(
      builder: (context, vm, _) {
        return Scaffold(
          backgroundColor: AppColors.white,
          body: Stack(
            children: [
              Column(
                children: [
                  Container(
                    color: AppColors.white,
                    padding: const EdgeInsets.fromLTRB(32, 60, 32, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset('lib/assets/cao_logo.png', height: 30),
                        GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage())),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(color: AppColors.black, shape: BoxShape.circle),
                            child: const Icon(PhosphorIconsRegular.user, color: AppColors.white, size: 24),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 120),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 20, offset: const Offset(0, 4))],
                        ),
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Saved Places', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                GestureDetector(
                                  onTap: _showAddFolderDialog,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                    decoration: BoxDecoration(color: AppColors.black, borderRadius: BorderRadius.circular(20)),
                                    child: const Text('+ Folder', style: TextStyle(color: AppColors.brandYellow, fontSize: 13, fontWeight: FontWeight.w600)),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            if (vm.isLoading)
                              const Center(child: CircularProgressIndicator(color: AppColors.brandYellow))
                            else if (vm.folders.isEmpty)
                              Center(child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 40),
                                child: Column(
                                  children: [
                                    Icon(PhosphorIconsRegular.bookmarkSimple, size: 48, color: Colors.grey.shade300),
                                    const SizedBox(height: 12),
                                    Text('No saved places yet', style: TextStyle(color: Colors.grey.shade400)),
                                  ],
                                ),
                              ))
                            else
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: 0.68,
                                ),
                                itemCount: vm.folders.length,
                                itemBuilder: (context, i) {
                                  final name = vm.folderNames[i];
                                  final places = vm.folders[name]!;
                                  return _buildFolderCard(context, name, places, vm);
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const BottomNavBar(currentIndex: 4),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFolderCard(BuildContext context, String name, places, SavedViewModel vm) {
    final images = places.take(4).map((p) => p.coverUrl).where((u) => u != null).cast<String>().toList();

    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(
        builder: (_) => FolderDetailPage(folderName: name),
      )),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Stack(
                children: [
                  // 2x2 photo grid
                  Column(
                    children: [
                      Row(
                        children: [
                          _thumb(images.isNotEmpty ? images[0] : null),
                          _thumb(images.length > 1 ? images[1] : null),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          _thumb(images.length > 2 ? images[2] : null),
                          _thumb(images.length > 3 ? images[3] : null),
                        ],
                      ),
                    ],
                  ),
                  // Delete button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => _showDeleteFolderDialog(name),
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 4)],
                        ),
                        child: const Icon(Icons.close, size: 14, color: AppColors.black),
                      ),
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
                  Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text('${places.length} places', style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _thumb(String? url) {
    return Expanded(
      child: url != null
          ? Image.network(url, height: 60, fit: BoxFit.cover)
          : Container(height: 60, color: Colors.grey.shade200,
              child: const Icon(Icons.image_outlined, color: Colors.grey, size: 20)),
    );
  }
}