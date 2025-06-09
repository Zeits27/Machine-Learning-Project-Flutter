import 'package:flutter/material.dart';
import 'songdetailpage.dart';

class ArtistDetailPage extends StatelessWidget {
  final String artist;
  final List<Map<String, String>> allRecommendations;

  const ArtistDetailPage({
    super.key,
    required this.artist,
    required this.allRecommendations,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        title: const Text(
          'Artist Details',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _artistDetailsSection(),
            const SizedBox(height: 24),
            Text(
              'Top Songs by $artist',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: allRecommendations.map((song) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E2E2E),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.grey,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                song['title'] ?? 'Unknown Title',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                song['artist'] ?? 'Unknown Artist',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        _greenButton("Play"),
                        const SizedBox(width: 8),
                        _darkButton("View", () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ArtistDetailPage(
                                artist: song['artist'] ?? 'Unknown Artist',
                                allRecommendations: allRecommendations
                                    .where((s) => s['artist'] == song['artist'])
                                    .toList(),
                              ),
                            ),
                          );
                        }),
                        const SizedBox(width: 8),
                        const Icon(Icons.favorite_border, color: Colors.green),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _artistDetailsSection() {
    return Row(
      children: [
        Container(
          width: 100,
          height: 100,
          color: Colors.grey,
          child: const Icon(Icons.person, color: Colors.white, size: 48),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _metadataRow("Artist", artist),
            const SizedBox(height: 8),
            Row(
              children: [
                _greenButton("Play"),
                const SizedBox(width: 8),
                const Icon(Icons.favorite_border, color: Colors.green),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _metadataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            "$label:",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Text(value, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _greenButton(String label) => ElevatedButton(
    onPressed: () {},
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF00FF7F),
      foregroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    child: Text(label),
  );

  Widget _darkButton(String label, VoidCallback onPressed) => ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF1A1A1A),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      side: const BorderSide(color: Colors.white24),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    child: Text(label),
  );
}
