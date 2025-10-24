import 'package:flutter/material.dart';

import '../models/article.dart';
import '../services/news_service.dart';
import '../widgets/article_tile.dart';

class NewsListScreen extends StatefulWidget {
  const NewsListScreen({super.key});

  @override
  State<NewsListScreen> createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  final NewsService _newsService = NewsService();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  final List<Article> _articles = <Article>[];
  List<Article> _filteredArticles = <Article>[];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  String _selectedCountry = 'us';
  String _query = '';
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchArticles();
    _scrollController.addListener(_onScroll);
    _searchController.addListener(_onSearchChanged);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading &&
        _hasMore &&
        _errorMessage == null) {
      _fetchArticles();
    }
  }

  void _onSearchChanged() {
    setState(() {
      _query = _searchController.text;
      _applyFilter();
    });
  }

  Future<void> _fetchArticles({bool reset = false}) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      if (reset) {
        _currentPage = 1;
        _articles.clear();
        _filteredArticles = <Article>[];
        _hasMore = true;
        _errorMessage = null;
      }
    });

    try {
      final fetchedArticles = await _newsService.fetchTopHeadlines(
        country: _selectedCountry,
        page: _currentPage,
      );

      setState(() {
        _errorMessage = null;
        if (reset) {
          _articles.clear();
        }
        _currentPage++;
        if (fetchedArticles.isEmpty) {
          _hasMore = false;
        } else {
          _articles.addAll(fetchedArticles);
          _applyFilter();
          if (fetchedArticles.length < 20) {
            _hasMore = false;
          }
        }
      });
    } on NewsServiceException catch (error) {
      setState(() {
        _errorMessage = error.message;
      });
      if (mounted && _articles.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message)),
        );
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Something went wrong. Please try again later.';
      });
      if (mounted && _articles.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to refresh articles.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _applyFilter() {
    final normalizedQuery = _query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) {
      _filteredArticles = List<Article>.from(_articles);
      return;
    }

    _filteredArticles = _articles.where((article) {
      final matchesTitle = article.title.toLowerCase().contains(normalizedQuery);
      final description = article.description?.toLowerCase() ?? '';
      final matchesDescription = description.contains(normalizedQuery);
      return matchesTitle || matchesDescription;
    }).toList();
  }

  void _changeCountry(String country) {
    if (_selectedCountry == country) {
      return;
    }
    setState(() {
      _selectedCountry = country;
    });
    _fetchArticles(reset: true);
  }

  Future<void> _refreshArticles() async {
    await _fetchArticles(reset: true);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search…',
            border: InputBorder.none,
          ),
          textInputAction: TextInputAction.search,
        ),
      ),
      body: Column(
        children: [
          _buildCountryChips(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshArticles,
              child: _buildArticleList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountryChips() {
    const countries = ['us', 'ca', 'gb', 'au', 'in'];
    return SizedBox(
      height: 56,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final country = countries[index];
          return ChoiceChip(
            label: Text(country.toUpperCase()),
            selected: _selectedCountry == country,
            onSelected: (selected) {
              if (selected) {
                _changeCountry(country);
              }
            },
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemCount: countries.length,
      ),
    );
  }

  Widget _buildArticleList() {
    if (_isLoading && _articles.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 160),
          Center(child: CircularProgressIndicator()),
        ],
      );
    }

    if (_errorMessage != null && _articles.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 120, horizontal: 24),
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
          const SizedBox(height: 12),
          Text(
            _errorMessage!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              onPressed: () => _fetchArticles(reset: true),
              child: const Text('Retry'),
            ),
          ),
        ],
      );
    }

    if (_filteredArticles.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 120, horizontal: 24),
        children: const [
          Icon(Icons.search_off, size: 48, color: Colors.grey),
          SizedBox(height: 12),
          Text(
            'No articles match your search.',
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: _filteredArticles.length + (_hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= _filteredArticles.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final article = _filteredArticles[index];
        return ArticleTile(article: article);
      },
    );
  }
}
