import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:frontend/core/api/api_client.dart';
import 'package:frontend/views/widgets/bottom_nav_bar.dart';
import 'package:frontend/views/pages/profile_page.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  @override
  void dispose() {
    // Auto mark all as read waktu keluar dari page
    ApiClient.instance.post('/notifications/read-all', {}, auth: true);
    super.dispose();
  }

  Future<void> _loadNotifications() async {
    setState(() => _isLoading = true);
    try {
      final res = await ApiClient.instance.get('/notifications', auth: true);
      final data = ApiClient.instance.parseResponse(res) as List;
      setState(() {
        _notifications = data.map((n) => Map<String, dynamic>.from(n)).toList();
        _isLoading = false;
      });
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  String _timeAgo(String? createdAt) {
    if (createdAt == null) return '';
    try {
      final dt = DateTime.parse(createdAt);
      final diff = DateTime.now().difference(dt);
      if (diff.inMinutes < 60) return '${diff.inMinutes} menit yang lalu';
      if (diff.inHours < 24) return '${diff.inHours} jam yang lalu';
      if (diff.inDays < 7) return '${diff.inDays} hari yang lalu';
      return '${(diff.inDays / 7).floor()} minggu yang lalu';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const ProfilePage())),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                            color: AppColors.black, shape: BoxShape.circle),
                        child: const Icon(PhosphorIconsRegular.user,
                            color: AppColors.white, size: 24),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: AppColors.brandYellow))
                    : _notifications.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(PhosphorIconsRegular.bell,
                                    size: 60, color: Colors.grey.shade300),
                                const SizedBox(height: 12),
                                Text('No notifications yet',
                                    style: TextStyle(
                                        color: Colors.grey.shade400, fontSize: 16)),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _loadNotifications,
                            color: AppColors.brandYellow,
                            child: ListView.builder(
                              padding: const EdgeInsets.fromLTRB(32, 8, 32, 120),
                              itemCount: _notifications.length,
                              itemBuilder: (_, i) {
                                final n = _notifications[i];
                                final isUnread = n['isRead'] == 0;
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: isUnread
                                        ? const Color(0xFFFFFBE6)
                                        : AppColors.white,
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(
                                      color: isUnread
                                          ? AppColors.brandYellow.withOpacity(0.4)
                                          : Colors.grey.shade200,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.05),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                            PhosphorIconsRegular.checkCircle,
                                            color: AppColors.black,
                                            size: 20),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    n['title'] ?? '',
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                                if (isUnread)
                                                  Container(
                                                    width: 8,
                                                    height: 8,
                                                    decoration: const BoxDecoration(
                                                        color: AppColors.brandYellow,
                                                        shape: BoxShape.circle),
                                                  ),
                                              ],
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              n['body'] ?? '',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey.shade600,
                                                  height: 1.3),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              _timeAgo(n['createdAt']?.toString()),
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.grey.shade400,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
              ),
            ],
          ),
          const BottomNavBar(currentIndex: 3),
        ],
      ),
    );
  }
}