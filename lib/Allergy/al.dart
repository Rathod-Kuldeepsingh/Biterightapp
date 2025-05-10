import 'package:flutter/material.dart';

class AllergyAlertScreen extends StatelessWidget {
  final String productName;
  final List<String> detectedAllergens;

  const AllergyAlertScreen({
    super.key,
    required this.productName,
    required this.detectedAllergens,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.red[700],
        title: Text('⚠️ Allergy Alert', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            
            // Warning Section
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red[100],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.red, size: 80),
                  SizedBox(height: 10),
                  Text(
                    "⚠️ Allergy Warning!",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.red[800]),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "This product may contain allergens!",
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Product Name
            Text(
              "🛒 Product: $productName",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 15),

            // Detected Allergens
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "🚨 Detected Allergens:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red[800]),
              ),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: detectedAllergens
                  .map((allergen) => Chip(
                        label: Text(allergen, style: TextStyle(color: Colors.white)),
                        backgroundColor: Colors.red[400],
                      ))
                  .toList(),
            ),

            Spacer(),

            // Back Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back, color: Colors.white),
                label: Text("Back to Product", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
