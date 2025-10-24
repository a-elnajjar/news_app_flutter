class Article {
  final String title;
  final String? description;
  final String? imageUrl;
  final String? author;
  final DateTime? publishedAt;
  final String? content;
  final String? url;
  final String? sourceName;

  const Article({
    required this.title,
    this.description,
    this.imageUrl,
    this.author,
    this.publishedAt,
    this.content,
    this.url,
    this.sourceName,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    final source = json['source'] as Map<String, dynamic>?;
    return Article(
      title: (json['title'] as String?)?.trim() ?? 'Untitled article',
      description: (json['description'] as String?)?.trim(),
      imageUrl: _asNonEmptyString(json['urlToImage'] ?? json['image']),
      author: _asNonEmptyString(json['author']),
      publishedAt: _parseDateTime(json['publishedAt'] as String?),
      content: (json['content'] as String?)?.trim(),
      url: _asNonEmptyString(json['url']),
      sourceName: _asNonEmptyString(source != null ? source['name'] : null),
    );
  }

  static String? _asNonEmptyString(Object? value) {
    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }
    return null;
  }

  static DateTime? _parseDateTime(String? raw) {
    if (raw == null || raw.isEmpty) {
      return null;
    }
    try {
      return DateTime.parse(raw);
    } catch (_) {
      return null;
    }
  }
}
