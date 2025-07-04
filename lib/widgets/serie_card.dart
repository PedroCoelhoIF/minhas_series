import 'package:flutter/material.dart';
import 'package:minhas_series/interface_usuario/detail_screen.dart';

class SerieCard extends StatelessWidget {
  final Map<String, dynamic> series;
  final Map<String, dynamic> user;
  
  final VoidCallback? onRefresh;

  const SerieCard({
    super.key,
    required this.series,
    required this.user,
    this.onRefresh, 
  });

  @override
  Widget build(BuildContext context) {
    
    final String posterPath = series['poster_path'] ?? '';
    final String imageUrl = posterPath.isNotEmpty
        ? 'https://image.tmdb.org/t/p/w500$posterPath'
        : '';

    return InkWell(
      
      onTap: () async {
        
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(series: series, user: user),
          ),
        );
        
        onRefresh?.call();
      },
      child: Card(
       
        elevation: 5,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (imageUrl.isNotEmpty)
              SizedBox(
                height: 250,
                child: Image.network(imageUrl, fit: BoxFit.cover),
              )
            else
              SizedBox(
                height: 250,
                child: Container(
                  color: Colors.grey[850],
                  child: const Center(
                    child: Icon(Icons.movie_creation_outlined, color: Colors.white, size: 60),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                series['name'],
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}