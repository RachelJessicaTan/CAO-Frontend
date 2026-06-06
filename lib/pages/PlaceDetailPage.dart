import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class PlaceDetailPage extends StatelessWidget {
  final Map<String, String> spot;

  const PlaceDetailPage({super.key, required this.spot});

  @override
  Widget build(BuildContext context) {
    const Color brandYellow = Color(0xFFFCDD3F);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero image + back button
            Stack(
              children: [
                Image.network(
                  spot['img']!,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 52,
                  left: 16,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back, size: 22, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),

            // White content with rounded top corners
            Transform.translate(
              offset: const Offset(0, -32),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                ),
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title + bookmark
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              spot['title']!,
                              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              spot['loc']!,
                              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(PhosphorIconsRegular.bookmarkSimple, color: Colors.white, size: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Suitable for
                    const Text(
                      'SUITABLE FOR',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.2),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ['Date Night', 'Hang Out', 'Studying', 'Solo Time'].map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            border: Border.all(color: brandYellow, width: 1.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(tag, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    const Divider(color: Color(0xFFEEEEEE)),
                    const SizedBox(height: 16),

                    // Hours
                    Row(
                      children: [
                        Icon(PhosphorIconsRegular.clock, size: 18, color: Colors.grey.shade500),
                        const SizedBox(width: 10),
                        const Text('Open', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                        const SizedBox(width: 8),
                        Text('07.00 - 21.00', style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Address
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(PhosphorIconsRegular.mapPin, size: 18, color: Colors.grey.shade500),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            spot['loc']!,
                            style: TextStyle(fontSize: 14, color: Colors.grey.shade600, height: 1.5),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Top Reviews
                    const Text(
                      'Top Reviews',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),

                    _buildReview('ws_alfonso', 'Nice place for chilling. Have good taste on Asian food. I like the way they serve the Cheese Parmigiana.'),
                    _buildReview('oliver', 'Best service!'),
                    _buildReview('gianazM', 'Cozy VIP room for meetings or family dinner.'),
                    _buildReview('croycloy', 'Amazing ambience and great food selection.'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReview(String username, String review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDE7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(username, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(review, style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.4)),
        ],
      ),
    );
  }
}