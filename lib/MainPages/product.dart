import 'package:biterightapp/Allergy/al.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';


class ProductDetailScreen extends StatefulWidget {

  final Map<String, dynamic> product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {

  List<String> userAllergies = [];
  List<String> detectedAllergens = [];

  @override
  void initState() {
    super.initState();
    _fetchUserAllergies();
  }
   Future<void> _fetchUserAllergies() async {
    List<String> allergies = await getUserAllergies();
    setState(() {
      userAllergies = allergies;
      detectedAllergens = _checkForAllergens(widget.product['ingredients_text'] ?? '');
    });

    if (detectedAllergens.isNotEmpty) {
      _navigateToAllergyAlert();
    }
  }
   Future<List<String>> getUserAllergies() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    return List<String>.from(userDoc.data()?['allergies'] ?? []);
  }
    List<String> _checkForAllergens(String ingredients) {
    return userAllergies.where((allergen) => ingredients.toLowerCase().contains(allergen.toLowerCase())).toList();
  }
void _navigateToAllergyAlert() {
    Future.delayed(Duration(milliseconds: 500), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AllergyAlertScreen(
            productName: widget.product['product_name'] ?? 'Unknown Product',
            detectedAllergens: detectedAllergens,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    
    
    final nutriments = widget.product['nutriments'] ?? {};
    final imageUrl = widget.product['image_url'];

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF27445D),
        title: Text(
          'Product Details',
          style: TextStyle(color: Colors.white),
        ),
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
              _buildProductCategory(
                  'Product Name', widget.product['product_name'] ?? 'N/A'),
              _buildProductCategory('Brand', widget.product['brands'] ?? 'N/A'),
              _buildProductCategory('Category', widget.product['categories'] ?? 'N/A'),
              _buildProductCategory(
                  'Ingredients', widget.product['ingredients_text'] ?? 'N/A'),
              SizedBox(height: 30),
              Divider(color: Color(0xFF27445D), thickness: 1.5),
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
              _buildNutrientItem('Energy (kcal)', nutriments['energy-kcal'],
                  2000), // 2000 kcal daily limit
              _buildNutrientItem(
                  'Fat (g)', nutriments['fat'], 70), // 70g fat daily limit
              _buildNutrientItem(
                  'Saturated Fat (g)', nutriments['saturated-fat'], 20),
              _buildNutrientItem(
                  'Carbohydrates (g)', nutriments['carbohydrates'], 260),
              _buildNutrientItem('Sugars (g)', nutriments['sugars'], 90),
              _buildNutrientItem('Protein (g)', nutriments['proteins'], 50),
              _buildNutrientItem('Salt (g)', nutriments['salt'], 6),
              _buildNutrientItem('Fiber (g)', nutriments['fiber'], 30),
              SizedBox(height: 20),

              if (nutriments.isNotEmpty) _buildNutritionChart(nutriments),
              _buildHealthScore(nutriments),
              _buildProductGrade(nutriments),
              SizedBox(
                height: 40,
              )
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

  List<String> harmfulNutrients = ['Fat (g)', 'Saturated Fat (g)', 'Sugars (g)', 'Salt (g)'];
  List<String> beneficialNutrients = ['Protein (g)', 'Fiber (g)'];

  Color levelColor = Colors.green;
  String harmLevel = "Healthy";
  String healthMessage = "Optimal level for a balanced diet."; // Default message

  if (harmfulNutrients.contains(name)) {
    if (percentage > 100) {
      levelColor = Colors.red;
      harmLevel = "Excessive";
      healthMessage = "High intake may increase health risks like obesity and heart issues.";
    } else if (percentage > 75) {
      levelColor = Colors.orange;
      harmLevel = "High";
      healthMessage = "Consider reducing intake to maintain a healthy balance.";
    } else if (percentage > 40) {
      levelColor = Colors.black;
      harmLevel = "Moderate";
      healthMessage = "Moderate levels are acceptable but should be monitored.";
    }
  } else if (beneficialNutrients.contains(name)) {
    if (percentage < 20) {
      levelColor = Colors.red;
      harmLevel = "Low";
      healthMessage = "Low levels may cause deficiencies, consider increasing intake.";
    } else if (percentage < 50) {
      levelColor = Colors.orange;
      harmLevel = "Moderate";
      healthMessage = "Moderate levels are good but increasing intake may be beneficial.";
    } else {
      levelColor = Colors.green;
      harmLevel = "Good";
      healthMessage = "Great! You are maintaining a healthy intake.";
    }
  }

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: (percentage / 100).clamp(0, 1),
            backgroundColor: Colors.grey[300],
            color: levelColor,
            minHeight: 12,
          ),
        ),
        SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              harmLevel,
              style: TextStyle(color: levelColor, fontWeight: FontWeight.w600, fontSize: 16),
            ),
            Text(
              "${actualValue.toStringAsFixed(1)} g",
              style: TextStyle(fontSize: 16, color: Colors.black54, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        SizedBox(height: 4),
        Text(
          healthMessage,
          style: TextStyle(fontSize: 14, color: Colors.blueGrey, fontStyle: FontStyle.italic),
        ),
      ],
    ),
  );
}

  Widget _buildNutritionChart(Map<String, dynamic> nutriments) {
    final List<String> labels = [
      'Energy',
      'Fat',
      'S.Fat',
      'Carbs',
      'Sugar',
      'Protein',
      'Salt',
      'Fiber'
    ];
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
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF27445D)),
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
                leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      int index = value.toInt();
                      if (index < 0 || index >= labels.length)
                        return Container();
                      return Text(labels[index],
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold));
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
                      color:
                          values[index] > 50 ? Colors.green : Colors.lightGreen,
                      width: 16,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
        SizedBox(
          height: 40,
        )
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
        color: Color(0xFF27445D),
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

Widget _buildProductGrade(Map<String, dynamic> nutriments) {
  double score = _calculateHealthScore(nutriments);
  String grade = _getHealthGrade(score);
  Color gradeColor = _getGradeColor(grade);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Divider(thickness: 1.5, color: Color(0xFF27445D)),
      Text(
        'Product Grade',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF27445D),
        ),
      ),
      SizedBox(height: 12),
      Row(
        children: [
          Text(
            'Grade: $grade',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: gradeColor,
            ),
          ),
          if (grade == 'E')
            Text(
              ' (Unhealthy)',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            )
          else if (grade == 'D')
            Text(
              ' (Needs Improvement)',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            )
          else if (grade == 'C')
            Text(
              ' (Average)',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
            )
          else if (grade == 'B')
            Text(
              ' (Good Choice)',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.lightGreen,
              ),
            )
          else if (grade == 'A')
            Text(
              ' (Excellent)',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            )
        ],
      ),
      SizedBox(height: 12),
      // Added explanation for the grading system
      Text(
        'How the grade is calculated:',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      SizedBox(height: 8),
      Text(
        'The product grade is based on several factors including the levels of harmful nutrients (e.g., fat, sugar, salt) and beneficial nutrients (e.g., protein, fiber). The score is calculated considering the balance between these nutrients and how they align with recommended daily values. A higher score means a healthier product, and lower scores indicate less healthy options.',
        style: TextStyle(
          fontSize: 14,
          color: Colors.black54,
        ),
      ),
      SizedBox(height: 8),
      Text(
        'Grades Explanation:',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      SizedBox(height: 8),
      Text(
        'A: Excellent - The product has a balanced amount of beneficial nutrients with minimal harmful ones. It\'s a great choice for your health.\n'
        'B: Good Choice - The product has some beneficial nutrients but may have higher amounts of one or two harmful ones.\n'
        'C: Average - The product has a mix of beneficial and harmful nutrients and may not be the best choice for your health.\n'
        'D: Needs Improvement - The product has too many harmful nutrients compared to beneficial ones. It\'s not the healthiest option.\n'
        'E: Unhealthy - The product has an excessive amount of harmful nutrients and should be consumed sparingly.',
        style: TextStyle(
          fontSize: 14,
          color: Colors.black54,
        ),
      ),
    ],
  );
}

String _getHealthGrade(double score) {
  if (score >= 80) return 'A';
  if (score >= 60) return 'B';
  if (score >= 40) return 'C';
  if (score >= 20) return 'D';
  return 'E';
}

Color _getGradeColor(String grade) {
  switch (grade) {
    case 'A':
      return Colors.green;
    case 'B':
      return Colors.lightGreen;
    case 'C':
      return Colors.orange;
    case 'D':
      return Colors.deepOrange;
    case 'E':
      return Colors.red;
    default:
      return Colors.grey;
  }
}
