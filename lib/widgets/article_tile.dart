import 'package:flutter/material.dart';

import '../models/article.dart';
import '../screens/article_detail_screen.dart';

class ArticleTile extends StatelessWidget {
  const ArticleTile({required this.article, super.key});

  final Article article;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final description = article.description ?? 'No description available.';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArticleDetailScreen(article: article),
            ),
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ArticleImage(imageUrl: article.imageUrl),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (article.sourceName != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        article.sourceName!,
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.primary),
                      ),
                    ],
                    const SizedBox(height: 6),
                    Text(
                      description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArticleImage extends StatelessWidget {
  const _ArticleImage({this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(4);
    final placeholder = ClipRRect(
      borderRadius: borderRadius,
      child: Container(
        width: 110,
        height: 110,
        color: Colors.grey.shade300,
        alignment: Alignment.center,
        child: const Icon(Icons.image, color: Colors.white70),
      ),
    );

    if (imageUrl == null) {
      return placeholder;
    }

    return ClipRRect(
      borderRadius: borderRadius,
      child: Image.network(
        imageUrl!,
        width: 110,
        height: 110,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => placeholder,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return SizedBox(
            width: 110,
            height: 110,
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }
}
