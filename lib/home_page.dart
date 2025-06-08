import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'recomendationpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? selectedCategory;
  String? recommendationAmount;
  TextEditingController inputController = TextEditingController();

  bool filterArtist = true;
  bool filterGenre = true;
  bool filterAlbum = true;

  List<String> songs = [];

  void addSong() {
    final text = inputController.text.trim();
    if (text.isNotEmpty && !songs.contains(text)) {
      setState(() {
        songs.add(text);
        inputController.clear();
      });
    }
  }

  void removeSong(String song) {
    setState(() {
      songs.remove(song);
    });
  }

  Future<void> fetchRecommendations() async {
    final baseUri = 'http://10.0.2.2:8080';
    final isBatch = songs.length > 1;
    final endpoint = isBatch ? '/recommend/batch' : '/recommend';
    final uri = Uri.parse('$baseUri$endpoint');

    final category = selectedCategory ?? 'song';
    final amount = int.tryParse(recommendationAmount ?? '5') ?? 5;

    List<String> filters = [];
    if (filterArtist) filters.add('artist');
    if (filterGenre) filters.add('genre');
    if (filterAlbum) filters.add('album');

    if (songs.isEmpty) {
      print("Please add at least one song or artist.");
      return;
    }

    final body = isBatch
        ? {
            "queries": songs,
            "search_by": category,
            "filter_by": filters.isEmpty ? null : filters,
            "number_of_recommendation": amount, // NOTE: key must match backend
            "recommend_type": "song",
          }
        : {
            "query": songs.first,
            "search_by": category,
            "filter_by": filters.isEmpty ? null : filters,
            "top_k": amount,
            "recommend_type": "song",
          };

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final rawRecs = data['recommendations'] as List;

        final recommendations = rawRecs.map<Map<String, String>>((rec) {
          return {
            'title': rec['track_name'] ?? 'Unknown Title', // Use 'track_name'
            'artist':
                rec['artist'] ??
                'Unknown Artist', // Use 'artist' (matches backend normalized key)
            'album': rec['album'] ?? '',
            'genre': rec['genre'] ?? '',
          };
        }).toList();

        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                RecommendationPage(recommendations: recommendations),
          ),
        );
      }
    } catch (e) {
      print("Error fetching recommendations: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black, elevation: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Find Similar Songs',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _sectionTitle('Select your recommendation Category'),
              _greenDropdown(
                value: selectedCategory,
                hint: 'Categories ...',
                items: ['Song', 'Artist'],
                onChanged: (value) => setState(() => selectedCategory = value),
              ),
              _sectionTitle('Insert Song Titles / Artist Names'),
              TextField(
                controller: inputController,
                style: const TextStyle(color: Colors.black),
                decoration: _greenInputDecoration('Type a song or artist '),
                onSubmitted: (_) => addSong(),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: songs.map((song) {
                  return Chip(
                    label: Text(song),
                    deleteIcon: const Icon(Icons.close),
                    onDeleted: () => removeSong(song),
                    backgroundColor: const Color(0xFF00FF7F),
                    labelStyle: const TextStyle(color: Colors.black),
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: addSong,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00FF7F),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Add More'),
              ),
              _sectionTitle('Choose amount of recommendations'),
              _greenDropdown(
                value: recommendationAmount,
                hint: 'Amount ...',
                items: ['1', '3', '5', '10'],
                onChanged: (value) =>
                    setState(() => recommendationAmount = value),
              ),
              const SizedBox(height: 20),
              _sectionTitle('Extra Filters (Optional)'),
              const SizedBox(height: 10),
              _filterCheckbox(
                'Artist',
                filterArtist,
                (val) => setState(() => filterArtist = val),
              ),
              _filterCheckbox(
                'Genre',
                filterGenre,
                (val) => setState(() => filterGenre = val),
              ),
              _filterCheckbox(
                'Album',
                filterAlbum,
                (val) => setState(() => filterAlbum = val),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _greenButton('Start', fetchRecommendations),
                  _greyButton('Save Changes', () {}),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 16),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _greenDropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: _greenInputDecoration(hint),
      dropdownColor: const Color(0xFF00FF7F),
      style: const TextStyle(color: Colors.black),
      iconEnabledColor: Colors.black,
      iconDisabledColor: Colors.black,
      items: items.map((e) {
        return DropdownMenuItem(
          value: e.toLowerCase(),
          child: Text(e, style: const TextStyle(color: Colors.black)),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  InputDecoration _greenInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFF00FF7F),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      hintStyle: const TextStyle(color: Colors.black),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  Widget _filterCheckbox(String label, bool value, Function(bool) onChanged) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: (val) => onChanged(val ?? false),
          activeColor: const Color(0xFF00FF7F),
        ),
        _greenButton(label, () {}),
      ],
    );
  }

  Widget _greenButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF00FF7F),
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(label),
    );
  }

  Widget _greyButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2E2E2E),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(label),
    );
  }
}
