import 'package:flutter/material.dart';

class SupportHelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Support & Help", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white) ),
        centerTitle: true,
        backgroundColor: Color(0xFF27445D),
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
             
                SizedBox(height: 30),
                _buildFeatureCard(Icons.help_outline, "FAQs", "Common questions and answers about the app."),
                _buildFeatureCard(Icons.support_agent, "Contact Support", "Email or chat with our support team."),
                _buildFeatureCard(Icons.bug_report, "Report an Issue", "Let us know if you find any problems."),
                _buildFeatureCard(Icons.book, "User Guide", "Learn how to use the app effectively."),
                _buildFeatureCard(Icons.feedback, "Feedback & Suggestions", "Share your thoughts to improve the app."),
                SizedBox(height: 150),
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
      ),
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, String subtitle) {
    return Card(
      elevation: 6,
      color: Colors.white,
      shadowColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: EdgeInsets.all(14),
                color: Color(0xFF27445D),
                child: Icon(icon, color: Colors.white, size: 30),
              ),
            ),
            SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                  SizedBox(height: 6),
                  Text(subtitle, style: TextStyle(fontSize: 15, color: Colors.grey[700])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
