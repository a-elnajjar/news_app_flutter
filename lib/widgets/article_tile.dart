import 'package:flutter/material.dart';
import '../models/article.dart';
import '../screens/article_detail_screen.dart';

class ArticleTile extends StatelessWidget {
  final Article article;

  ArticleTile({required this.article});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 100,
        height: 100,
        color: Colors.grey, // Placeholder color
        child: article.urlToImage != null
            ? Image.network(
                article.urlToImage!,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                  return Icon(Icons.broken_image, color: Colors.white); // Placeholder icon for error
                },
              )
            : Icon(Icons.image, color: Colors.white), // Placeholder icon
      ),
      title: Text(
        article.title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        article.description,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleDetailScreen(article: article),
          ),
        );
      },
    );
  }
}
