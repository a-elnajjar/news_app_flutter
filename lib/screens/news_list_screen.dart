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
  final TextEditingController _searchController = TextEditingController();

  List<Article> _articles = [];
  List<Article> _filteredArticles = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  String _selectedCountry = 'us'; 
  String _query = '';

  @override
  void initState() {
    super.initState();
    _fetchArticles();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && _hasMore) {
        _fetchArticles();
      }
    });

    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      _query = _searchController.text;
      _filterArticles();
    });
  }

  Future<void> _fetchArticles() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    try {
      List<Article> fetchedArticles = await newsService.fetchTopHeadlines(country: _selectedCountry, page: _currentPage);
      setState(() {
        _currentPage++;
        if (fetchedArticles.isEmpty) {
          _hasMore = false;
        } else {
          _articles.addAll(fetchedArticles);
          _filterArticles();
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

  void _filterArticles() {
    if (_query.isEmpty) {
      _filteredArticles = _articles;
    } else {
      _filteredArticles = _articles
          .where((article) =>
              article.title.toLowerCase().contains(_query.toLowerCase()) ||
              article.description.toLowerCase().contains(_query.toLowerCase()))
          .toList();
    }
  }

  void _changeCountry(String country) {
    setState(() {
      _selectedCountry = country;
      _currentPage = 1;
      _articles.clear();
      _hasMore = true;
    });
    _fetchArticles();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(color: Colors.grey), // Set hint text color to grey
            filled: true,
            fillColor: Colors.white, // Set background color to white
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.blue), // Set border color to blue
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.grey), // Set border color when enabled to grey
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.blue), // Set border color when focused to blue
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0), // Set padding inside the text field
          ),
          style: TextStyle(color: Colors.black), 
        ),
      ),
      body: Column(
        children: [
          _buildCountryChips(),
          Expanded(
            child: _filteredArticles.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: _filteredArticles.length + 1,
                    itemBuilder: (context, index) {
                      if (index == _filteredArticles.length) {
                        return _hasMore ? Center(child: CircularProgressIndicator()) : Container();
                      }
                      final article = _filteredArticles[index];
                      return ArticleTile(article: article);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountryChips() {
    final countries = ['us', 'ca', 'gb', 'au', 'in'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: countries.map((country) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ChoiceChip(
              label: Text(country.toUpperCase()),
              selected: _selectedCountry == country,
              onSelected: (selected) {
                if (selected) {
                  _changeCountry(country);
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
