class Article {
  final String title;
  final String imageUrl;
  final String content;

  Article({required this.title, required this.imageUrl, required this.content});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? 'No Title Available',
      imageUrl: json['image'] ?? 'https://via.placeholder.com/150',
      content: json['restaurantChain'] ?? 'Delicious food from a great place!',
    );
  }

  // Function to return a short content preview
  String get briefContent {
    return content.length > 50 ? '${content.substring(0, 50)}...' : content;
  }
}
