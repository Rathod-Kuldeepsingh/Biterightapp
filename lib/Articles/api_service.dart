import 'dart:convert';
import 'package:http/http.dart' as http;
import 'article.dart';

class ApiService {
  static const String apiKey = 'a4e46c482ab04e458e6d65fac7dcc1d6'; // Use your API Key
  static const String apiUrl = 'https://api.spoonacular.com/food/menuItems/search';

  // Fetch a minimum of 50 products and support pagination if needed
  static Future<List<Article>> fetchArticles() async {
    final List<Article> articles = [];
    int offset = 0;
    const int limit = 50;  // Number of items per page

    while (true) {
      final response = await http.get(Uri.parse('$apiUrl?query=all&apiKey=$apiKey&number=$limit&offset=$offset'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['menuItems'] != null && data['menuItems'].isNotEmpty) {
          final List<Article> fetchedArticles = data['menuItems'].map<Article>((json) => Article.fromJson(json)).toList();
          articles.addAll(fetchedArticles);

          // Check if we have fetched enough articles or need more
          if (fetchedArticles.length < limit) {
            break; // Break the loop if we have less than the limit
          } else {
            offset += limit; // Otherwise, go to the next page
          }
        } else {
          break; // No articles found, exit the loop
        }
      } else {
        throw Exception('Failed to load articles: ${response.statusCode}');
      }
    }
    return articles; // Return the complete list of fetched articles
  }
}
