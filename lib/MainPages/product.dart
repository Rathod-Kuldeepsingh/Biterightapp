import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ProductDetailScreen extends StatelessWidget {
  final Map<String, dynamic> product;
  

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    
    final nutriments = product['nutriments'] ?? {};
    final imageUrl = product['image_url'];

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor:  Color(0xFF27445D),
        title: Text('Product Details',
        style: TextStyle(
          color: Colors.white
        ),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imageUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrl,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                ),
              SizedBox(height: 20),
              Divider(color: Color(0xFF27445D), thickness: 1.5),
              Text(
                'Product Overview',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF27445D),
                ),
              ),
              SizedBox(height: 24),
              _buildProductCategory('Product Name', product['product_name'] ?? 'N/A'),
              _buildProductCategory('Brand', product['brands'] ?? 'N/A'),
              _buildProductCategory('Category', product['categories'] ?? 'N/A'),
              _buildProductCategory('Ingredients', product['ingredients_text'] ?? 'N/A'),
              SizedBox(height: 30),
              Divider(color:Color(0xFF27445D), thickness: 1.5),
              SizedBox(height: 20),
              Text(
                'Nutrition Information',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF27445D),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              _buildNutrientItem('Energy (kcal)', nutriments['energy-kcal'], 2000), // 2000 kcal daily limit
              _buildNutrientItem('Fat (g)', nutriments['fat'], 70), // 70g fat daily limit
              _buildNutrientItem('Saturated Fat (g)', nutriments['saturated-fat'], 20),
              _buildNutrientItem('Carbohydrates (g)', nutriments['carbohydrates'], 260),
              _buildNutrientItem('Sugars (g)', nutriments['sugars'], 90),
              _buildNutrientItem('Protein (g)', nutriments['proteins'], 50),
              _buildNutrientItem('Salt (g)', nutriments['salt'], 6),
              _buildNutrientItem('Fiber (g)', nutriments['fiber'], 30),
              SizedBox(height: 20),
              
              if (nutriments.isNotEmpty) _buildNutritionChart(nutriments),
               _buildHealthScore(nutriments),
               SizedBox(height: 40,)
            ],
          ),
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

  Widget _buildNutrientItem(String name, dynamic value, double dailyLimit) {
  double actualValue = (value?.toDouble() ?? 0.0);
  double percentage = (actualValue / dailyLimit) * 100;

  // Harmful nutrients: High values are bad
  List<String> harmfulNutrients = ['Fat (g)', 'Saturated Fat (g)', 'Sugars (g)', 'Salt (g)'];
  
  // Beneficial nutrients: Higher is not necessarily bad
  List<String> beneficialNutrients = ['Protein (g)', 'Fiber (g)'];

  Color levelColor = Colors.red;
  String harmLevel = "Low";

  if (harmfulNutrients.contains(name)) {
    if (percentage > 100) {
      levelColor = Colors.red;
      harmLevel = "Excessive";
    } else if (percentage > 75) {
      levelColor = Colors.orange;
      harmLevel = "High";
    } else if (percentage > 40) {
      levelColor = Colors.black;
      harmLevel = "Moderate";
    }
  } 
  else if (beneficialNutrients.contains(name)) {
    // Protein and Fiber are good; no need for a red warning
    harmLevel = "Good";
    levelColor = Colors.green;
  }

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 4),
            Text(
              "$actualValue g (${percentage.toStringAsFixed(1)}% of daily intake)",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: levelColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            harmLevel,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );
}


  Widget _buildNutritionChart(Map<String, dynamic> nutriments) {
    final List<String> labels = ['Energy', 'Fat', 'S.Fat', 'Carbs', 'Sugar', 'Protein', 'Salt', 'Fiber'];
    final List<double> values = [
      nutriments['energy-kcal']?.toDouble() ?? 0.0,
      nutriments['fat']?.toDouble() ?? 0.0,
      nutriments['saturated-fat']?.toDouble() ?? 0.0,
      nutriments['carbohydrates']?.toDouble() ?? 0.0,
      nutriments['sugars']?.toDouble() ?? 0.0,
      nutriments['proteins']?.toDouble() ?? 0.0,
      nutriments['salt']?.toDouble() ?? 0.0,
      nutriments['fiber']?.toDouble() ?? 0.0,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Divider(thickness: 1.5, color: Color(0xFF27445D)),
        Text(
          'Nutritional Chart',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF27445D)),
        ),
        SizedBox(height: 60),
        AspectRatio(
          aspectRatio: 1.5,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: values.reduce((a, b) => a > b ? a : b) + 5,
              barTouchData: BarTouchData(enabled: true),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      int index = value.toInt();
                      if (index < 0 || index >= labels.length) return Container();
                      return Text(labels[index], style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold));
                    },
                    interval: 1,
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              gridData: FlGridData(show: true),
              barGroups: List.generate(labels.length, (index) {
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: values[index],
                      color: values[index] > 50 ? Colors.green : Colors.lightGreen,
                      width: 16,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
    SizedBox(height: 40,)
      ],
    );
  }
}
 Widget _buildHealthScore(Map<String, dynamic> nutriments) {
  double score = _calculateHealthScore(nutriments);
  Color scoreColor = score >= 80
      ? Colors.green
      : score >= 50
          ? Colors.orange
          : Colors.red;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Divider(
        thickness: 1.5,
        color:Color(0xFF27445D),
      ),
      Text(
        'Health Score',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF27445D),
         
        ),
      ),
      SizedBox(height: 12),
      Row(
        children: [
          Icon(
            score >= 80
                ? Icons.check_circle_outline
                : score >= 50
                    ? Icons.warning_amber_outlined
                    : Icons.error_outline,
            color: scoreColor,
            size: 30,
          ),
          SizedBox(width: 8),
          Text(
            'Score: ${score.toStringAsFixed(1)} / 100',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: scoreColor,
            ),
          ),
        ],
      ),
      SizedBox(height: 12),
      LinearProgressIndicator(
        value: score / 100,
        backgroundColor: Colors.grey[200],
        color: scoreColor,
        minHeight: 12,
      ),
      SizedBox(height: 8),
      Text(
        score >= 80
            ? 'Great health!'
            : score >= 50
                ? 'Good, but could be better.'
                : 'Needs improvement!',
        style: TextStyle(
          fontSize: 16,
          color: scoreColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );
}

  double _calculateHealthScore(Map<String, dynamic> nutriments) {
    List<String> harmfulNutrients = ['fat', 'saturated-fat', 'sugars', 'salt'];
    List<String> beneficialNutrients = ['proteins', 'fiber'];

    double harmfulScore = 0;
    double beneficialScore = 0;

    for (String nutrient in harmfulNutrients) {
      double value = nutriments[nutrient]?.toDouble() ?? 0;
      if (value > 0) harmfulScore += value;
    }

    for (String nutrient in beneficialNutrients) {
      double value = nutriments[nutrient]?.toDouble() ?? 0;
      beneficialScore += value;
    }

    double healthScore = (beneficialScore / (harmfulScore + 1)) * 100;
    return healthScore.clamp(0, 100);
  }