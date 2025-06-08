import 'package:flutter/material.dart';

class SongDetailPage extends StatelessWidget {
  final Map<String, String> song;
  final List<Map<String, String>> allRecommendations;

  const SongDetailPage({
    super.key,
    required this.song,
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
          'Song Details',
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
            _songDetailsSection(),
            const SizedBox(height: 24),
            const Text(
              'More Like This',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: allRecommendations
                    .where((s) => s['title'] != song['title'])
                    .map((similar) => _songTile(context, similar))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _songDetailsSection() {
    return Row(
      children: [
        Container(
          width: 100,
          height: 100,
          color: Colors.grey,
          child: const Icon(Icons.music_note, color: Colors.white, size: 48),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _metadataRow("Album", song['album'] ?? 'Unknown'),
            _metadataRow("Title", song['title'] ?? 'Unknown'),
            _metadataRow("Artist", song['artist'] ?? 'Unknown'),
            _metadataRow("Genre", song['genre'] ?? 'Unknown'),
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

  Widget _songTile(BuildContext context, Map<String, String> song) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2E2E2E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const CircleAvatar(radius: 24, backgroundColor: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  song['title'] ?? 'Song Title',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  song['artist'] ?? 'Artist Name',
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
                builder: (context) => SongDetailPage(
                  song: song,
                  allRecommendations: allRecommendations,
                ),
              ),
            );
          }),
          const SizedBox(width: 8),
          const Icon(Icons.favorite_border, color: Colors.green),
        ],
      ),
    );
  }

  Widget _greenButton(String label) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF00FF7F),
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(label),
    );
  }

  Widget _darkButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
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
}
