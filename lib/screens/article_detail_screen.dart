import 'package:flutter/material.dart';

import '../models/article.dart';

class ArticleDetailScreen extends StatelessWidget {
  const ArticleDetailScreen({required this.article, super.key});

  final Article article;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final details = <String>[
      if (article.sourceName?.isNotEmpty ?? false) article.sourceName!,
      if (article.author?.isNotEmpty ?? false) article.author!,
    ].join(' • ');
    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(article.imageUrl!),
              ),
            const SizedBox(height: 16.0),
            Text(
              article.title,
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            if (details.isNotEmpty)
              Text(
                details,
                style: theme.textTheme.labelMedium,
              ),
            if (article.publishedAt != null) ...[
              const SizedBox(height: 4),
              Text(
                _formatPublishedDate(article.publishedAt!),
                style: theme.textTheme.labelSmall,
              ),
            ],
            const SizedBox(height: 16.0),
            Text(
              article.description ?? 'No description available for this article.',
              style: theme.textTheme.bodyLarge,
            ),
            if (article.content != null) ...[
              const SizedBox(height: 16.0),
              Text(
                article.content!,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatPublishedDate(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  }
}
