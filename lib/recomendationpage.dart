import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'recomendationpage.dart';
import 'songdetailpage.dart';
import 'artistdetailpage.dart';
import 'albumdetailpage.dart';

class RecommendationPage extends StatelessWidget {
  final List<Map<String, String>> recommendations;

  const RecommendationPage({super.key, required this.recommendations});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        title: const Text(
          'For You',
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
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: recommendations.length,
                itemBuilder: (context, index) {
                  final song = recommendations[index];
                  final category = (song['recommendation_type'] ?? 'song')
                      .toLowerCase();

                  String title = '';
                  String subtitle = '';
                  final artistName = song['artist'] ?? 'Unknown Artist';
                  final popularity = song['popularity'] ?? 'N/A';

                  if (category == 'artist') {
                    title = artistName;
                    subtitle = 'Popularity: $popularity';
                  } else if (category == 'album') {
                    title = song['album'] ?? 'Unknown Album';
                    subtitle = 'Artist: $artistName';
                  } else {
                    title = song['title'] ?? 'Unknown Title';
                    subtitle = artistName;
                  }

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
                                title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                subtitle,
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
                          if (category == 'artist') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ArtistDetailPage(
                                  artist: artistName,
                                  popularity: popularity,
                                  allRecommendations:
                                      recommendations, // Pass full list
                                ),
                              ),
                            );
                          } else if (category == 'album') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AlbumDetailPage(
                                  album: song['album'] ?? 'Unknown Album',
                                  artist: artistName,
                                  popularity: popularity,
                                  allRecommendations: recommendations,
                                ),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SongDetailPage(
                                  song: song,
                                  allRecommendations: recommendations,
                                ),
                              ),
                            );
                          }
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
