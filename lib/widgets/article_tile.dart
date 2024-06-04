import 'package:flutter/material.dart';
import '../models/article.dart';
import '../screens/article_detail_screen.dart';

class ArticleTile extends StatelessWidget {
  final Article article;

  ArticleTile({required this.article});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: article.urlToImage != null
          ? Image.network(article.urlToImage!, width: 100, fit: BoxFit.cover)
          : Container(width: 100, color: Colors.grey), // Placeholder for null image
      title: Text(article.title),
      subtitle: Text(article.description),
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
