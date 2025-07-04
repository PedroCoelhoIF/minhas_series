import 'package:flutter/material.dart';
import 'package:minhas_series/bd/database_helper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:minhas_series/secrets.dart';

class DetailScreen extends StatefulWidget {
  final Map<String, dynamic> series;
  final Map<String, dynamic> user;

  const DetailScreen({super.key, required this.series, required this.user});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final dbHelper = DatabaseHelper();
  final _commentController = TextEditingController();

 
  Map<String, dynamic>? _seriesDetails; 
  double _userRating = 0.0;
  String? _seriesStatus;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  
  Future<void> _loadAllData() async {
   
    await Future.wait([
      _fetchApiDetails(),
      _loadUserSeriesData(),
    ]);

    
    setState(() {
      _isLoading = false;
    });
  }

 
  Future<void> _fetchApiDetails() async {
    final seriesId = widget.series['id'];
    final url = Uri.parse('https://api.themoviedb.org/3/tv/$seriesId');
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
          _seriesDetails = jsonDecode(response.body);
        });
      }
    } catch (e) {
      print('Erro ao buscar detalhes da API: $e');
    }
  }

  
  Future<void> _loadUserSeriesData() async {
    final seriesId = widget.series['id'];
    final userId = widget.user['id'];
    final savedData = await dbHelper.getSeriesById(seriesId, userId);

    if (savedData != null) {
      setState(() {
        _seriesStatus = savedData['status'];
        _userRating = savedData['rating'] ?? 0.0;
        _commentController.text = savedData['comment'] ?? '';
      });
    }
  }

  void _saveSeriesData(String status) async {
    
    final seriesData = {
      'id': widget.series['id'],
      'user_id': widget.user['id'],
      'name': widget.series['name'],
      'poster_path': widget.series['poster_path'],
      'status': status,
      'rating': _userRating,
      'comment': _commentController.text,
    };
    await dbHelper.saveSeries(seriesData);
    setState(() { _seriesStatus = status; });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Série salva com sucesso!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _deleteSeries() async {
    
    await dbHelper.deleteSeries(widget.series['id'], widget.user['id']);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Série removida da sua lista.'),
        backgroundColor: Colors.red,
      ),
    );
    Navigator.pop(context);
  }

  Widget _buildRatingStars() {
  
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < _userRating ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 35,
          ),
          onPressed: () {
            setState(() { _userRating = index + 1.0; });
          },
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    final String backdropPath = _seriesDetails?['backdrop_path'] ?? widget.series['backdrop_path'] ?? '';
    final String imageUrl = backdropPath.isNotEmpty
        ? 'https://image.tmdb.org/t/p/w780$backdropPath'
        : '';

    return Scaffold(
      appBar: AppBar(title: Text(widget.series['name'])),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _seriesDetails == null
            ? const Center(child: Text('Não foi possível carregar os detalhes da série.'))
            : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (imageUrl.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(imageUrl),
                    ),
                  const SizedBox(height: 20),
                  Text(_seriesDetails!['name'],
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(
                    
                    (_seriesDetails!['overview'] ?? '').isNotEmpty
                      ? _seriesDetails!['overview']
                      : 'Sinopse não disponível.',
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 10),
                  const Text('Minha Avaliação',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  _buildRatingStars(),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      labelText: 'Meus Comentários',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 20),
                  Text('Salvar em:',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                           ElevatedButton(
                            onPressed: () => _saveSeriesData('watching'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _seriesStatus == 'watching' ? Colors.blueAccent : null,
                            ),
                            child: const Text('Assistindo'),
                          ),
                          ElevatedButton(
                            onPressed: () => _saveSeriesData('planned'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _seriesStatus == 'planned' ? Colors.blueAccent : null,
                            ),
                            child: const Text('Quero Ver'),
                          ),
                          ElevatedButton(
                            onPressed: () => _saveSeriesData('finished'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _seriesStatus == 'finished' ? Colors.blueAccent : null,
                            ),
                            child: const Text('Já Vi'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextButton.icon(
                        onPressed: _deleteSeries,
                        icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                        label: const Text('Remover da Lista', style: TextStyle(color: Colors.redAccent)),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}