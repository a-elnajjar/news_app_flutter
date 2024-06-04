import 'package:flutter/material.dart';
import '../services/news_service.dart';
import '../models/article.dart';
import '../widgets/article_tile.dart';

class NewsListScreen extends StatefulWidget {
  @override
  _NewsListScreenState createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  final NewsService newsService = NewsService();
  final ScrollController _scrollController = ScrollController();
  
  List<Article> _articles = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _fetchArticles();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && _hasMore) {
        _fetchArticles();
      }
    });
  }

  Future<void> _fetchArticles() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });
    
    try {
      List<Article> fetchedArticles = await newsService.fetchTopHeadlines(page: _currentPage);
      setState(() {
        _currentPage++;
        if (fetchedArticles.isEmpty) {
          _hasMore = false;
        } else {
          _articles.addAll(fetchedArticles);
        }
      });
    } catch (e) {
      print('Error fetching articles: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _articles.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              controller: _scrollController,
              itemCount: _articles.length + 1,
              itemBuilder: (context, index) {
                if (index == _articles.length) {
                  return _hasMore ? Center(child: CircularProgressIndicator()) : Container();
                }
                final article = _articles[index];
                return ArticleTile(article: article);
              },
            ),
    );
  }
}
