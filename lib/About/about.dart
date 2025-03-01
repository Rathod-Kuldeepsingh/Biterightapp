import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("About Us", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: Color(0xFF27445D),
        elevation: 0,
      ),
      body: Container(
       color: Colors.white,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        color: Color(0xFF27445D),
                        padding: EdgeInsets.all(16),
                        child: Icon(Icons.health_and_safety, size: 80, color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      "BiteRight",style: GoogleFonts.hennyPenny(textStyle: TextStyle(fontSize: 30,fontWeight: FontWeight.w600,color: Color(0xFF27445D) )),
                      // ,
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Helping you make healthier food choices!",
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Divider(color: Color(0xFF27445D).withOpacity(0.5), thickness: 1.5),
              SizedBox(height: 10),
              Text("Key Features", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF27445D))),
              SizedBox(height: 10),
              _buildFeatureCard(Icons.qr_code_scanner, "Barcode/QR Scanner", "Scan products for instant details."),
              _buildFeatureCard(Icons.bar_chart, "Nutritional Breakdown", "Get in-depth analysis of nutrients."),
              _buildFeatureCard(Icons.warning, "Harmful Additive Alerts", "Avoid unhealthy ingredients."),
              _buildFeatureCard(Icons.recommend, "Personalized Recommendations", "Based on your health conditions."),
              // _buildFeatureCard(Icons.local_dining, "Allergy & Dietary Filters", "Find suitable products for you."),
              _buildFeatureCard(Icons.swap_horiz, "Healthier Alternatives", "Discover better food choices."),
              SizedBox(height: 20),
              Divider(color: Color(0xFF27445D).withOpacity(0.5), thickness: 1.5),
              SizedBox(height: 10),
              Text("Contact Us", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF27445D))),
              SizedBox(height: 10),
              _buildContactItem(Icons.email, "support@biteright.com", "Email us for queries & feedback"),
              _buildContactItem(Icons.public, "www.biteright.com", "Visit our website"),
              _buildContactItem(Icons.lock, "Privacy Policy & Terms", "Learn more about our policies"),
              SizedBox(height: 20),
              Center(
                child: Text(
                  "© 2025 BiteRight. All Rights Reserved.",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, String subtitle) {
    return Card(
      color: Colors.white,
      shadowColor: Colors.black,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: EdgeInsets.all(12),
                color: Color(0xFF27445D),
                child: Icon(icon, color: Colors.white, size: 28),
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFF27445D), size: 28),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
    );
  }
}