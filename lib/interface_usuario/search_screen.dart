import 'package:flutter/material.dart';
import 'package:minhas_series/widgets/serie_card.dart'; 
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:minhas_series/secrets.dart';

class SearchScreen extends StatefulWidget {

  final Map<String, dynamic> user;
  const SearchScreen({super.key, required this.user});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List _seriesResults = [];

  Future<void> _searchSeries(String query) async {
    if (query.isEmpty) {
      setState(() { _seriesResults = []; });
      return;
    }
    final url = Uri.parse('https://api.themoviedb.org/3/search/tv?query=$query');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $tmdbApiKey',
          'accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          _seriesResults = jsonDecode(response.body)['results'];
        });
      }
    } catch (error) {
      print('Erro na busca: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Séries'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Digite o nome da série...',
                suffixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _searchSeries,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _seriesResults.length,
                itemBuilder: (context, index) {
                  final series = _seriesResults[index];
                 
                  return SerieCard(series: series, user: widget.user, onRefresh: () {},);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}