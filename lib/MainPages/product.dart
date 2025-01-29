import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailScreen({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nutriments = product['nutriments'] ?? {};
    final imageUrl = product['image_url'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with proper fitting and size
            if (imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.fitHeight,
                ),
              ),
            SizedBox(height: 20),
            Divider(color: Colors.blueAccent, thickness: 1.5),
            Text(
              'Product Overview',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 24),
            _buildProductCategory('Product Name', product['product_name'] ?? 'N/A'),
            _buildProductCategory('Brand', product['brands'] ?? 'N/A'),
            _buildProductCategory('Category', product['categories'] ?? 'N/A'),
            _buildProductCategory('Ingredients', product['ingredients_text'] ?? 'N/A'),
            SizedBox(height: 30),
            Divider(color: Colors.blueAccent, thickness: 1.5),
            SizedBox(height: 20),
            Text(
              'Nutrition Information',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            _buildProductCategory('Energy (kcal)', nutriments['energy-kcal']?.toString() ?? 'N/A'),
            _buildProductCategory('Fat (g)', nutriments['fat']?.toString() ?? 'N/A'),
            _buildProductCategory('Saturated Fat (g)', nutriments['saturated-fat']?.toString() ?? 'N/A'),
            _buildProductCategory('Carbohydrates (g)', nutriments['carbohydrates']?.toString() ?? 'N/A'),
            _buildProductCategory('Sugars (g)', nutriments['sugars']?.toString() ?? 'N/A'),
            _buildProductCategory('Protein (g)', nutriments['proteins']?.toString() ?? 'N/A'),
            _buildProductCategory('Salt (g)', nutriments['salt']?.toString() ?? 'N/A'),
            _buildProductCategory('Fiber (g)', nutriments['fiber']?.toString() ?? 'N/A'),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCategory(String category, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
