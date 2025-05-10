import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

const String apiKey = "f0832778574446d39910d56a75bbae1c";
const String baseUrl = "https://newsapi.org/v2/everything";

/// Fetches only food-related news articles
Future<List<Map<String, dynamic>>> fetchFoodArticles() async {
  final Uri url = Uri.parse(
      "$baseUrl?q=food&language=en&sortBy=publishedAt&pageSize=50&apiKey=$apiKey");

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    List<Map<String, dynamic>> articles = List<Map<String, dynamic>>.from(
        data["articles"]?.where((article) =>
            article["urlToImage"] != null &&
            (article["title"].toLowerCase().contains("food") ||
                article["title"].toLowerCase().contains("nutrition") ||
                article["title"].toLowerCase().contains("diet") ||
                article["title"].toLowerCase().contains("healthy") ||
                article["description"].toLowerCase().contains("food") ||
                article["description"].toLowerCase().contains("nutrition") ||
                article["description"].toLowerCase().contains("diet") ||
                article["description"].toLowerCase().contains("healthy"))) ??
            []);

    return articles.take(20).toList();
  } else {
    throw Exception("Error fetching articles: ${response.statusCode}");
  }
}

/// Food News Screen
class FoodNewsScreen extends StatefulWidget {
  @override
  _FoodNewsScreenState createState() => _FoodNewsScreenState();
}

class _FoodNewsScreenState extends State<FoodNewsScreen> {
  late Future<List<Map<String, dynamic>>> _articlesFuture;

  @override
  void initState() {
    super.initState();
    _fetchArticles();
  }

  Future<void> _fetchArticles() async {
    setState(() {
      _articlesFuture = fetchFoodArticles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        color: Colors.black,
        backgroundColor: Colors.white,
        onRefresh: _fetchArticles,
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _articlesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(
                color: Colors.black,
              ));
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No food articles found'));
            }

            final articles = snapshot.data!;
            return ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return Card(
                  color: Colors.white,
                  margin: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 5,
                  child: InkWell(
                    onTap: () => _openArticle(article['url']),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (article['urlToImage'] != null)
                          ClipRRect(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(10)),
                            child: Image.network(
                              article['urlToImage'],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 200,
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(article['title'],
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis),
                              SizedBox(height: 5),
                              Text(article['source']['name'],
                                  style: TextStyle(color: Colors.grey[600])),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _openArticle(String url) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    }
  }
}
