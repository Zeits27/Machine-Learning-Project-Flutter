import 'package:flutter/material.dart';

class AlbumDetailPage extends StatelessWidget {
  final String album;
  final String artist;
  final String popularity;
  final List<Map<String, String>> allRecommendations;

  const AlbumDetailPage({
    super.key,
    required this.album,
    required this.artist,
    required this.popularity,
    required this.allRecommendations,
  });

  @override
  Widget build(BuildContext context) {
    final albumRecommendations = allRecommendations
        .where(
          (item) =>
              (item['recommendation_type'] ?? '').toLowerCase() == 'album' &&
              (item['album'] ?? '') != album,
        )
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        title: Text(
          album,
          style: const TextStyle(
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
          children: [
            _albumHeader(),
            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'More Albums You May Like',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: albumRecommendations.length,
                itemBuilder: (context, index) {
                  final item = albumRecommendations[index];
                  final name = item['album'] ?? 'Unknown Album';
                  final artistName = item['artist'] ?? 'Unknown Artist';
                  final pop = item['popularity'] ?? 'N/A';

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
                                name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Artist: $artistName',
                                style: const TextStyle(color: Colors.grey),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
                              builder: (context) => AlbumDetailPage(
                                album: name,
                                artist: artistName,
                                popularity: pop,
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
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _albumHeader() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          child: Icon(Icons.album, color: Colors.white, size: 40),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              album,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text("Artist: $artist", style: const TextStyle(color: Colors.grey)),
            Text(
              "Popularity: $popularity",
              style: const TextStyle(color: Colors.grey),
            ),
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

  Widget _greenButton(String label) => ElevatedButton(
    onPressed: () {},
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF00FF7F),
      foregroundColor: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    child: Text(label),
  );

  Widget _darkButton(String label, VoidCallback onPressed) => ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF444444),
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    child: Text(label),
  );
}
