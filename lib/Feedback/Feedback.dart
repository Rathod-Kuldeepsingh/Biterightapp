import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _feedbackController = TextEditingController();
  int _rating = 0;
  bool _isSubmitting = false;

  Future<void> _submitFeedback() async {
    if (_feedbackController.text.isEmpty || _rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please provide feedback and a rating.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      User? user = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance.collection('feedbacks').add({
        'userId': user?.uid ?? 'Anonymous',
        'email': user?.email ?? 'No Email',
        'feedback': _feedbackController.text,
        'rating': _rating,
        'timestamp': FieldValue.serverTimestamp(),
      });

      setState(() {
        _feedbackController.clear();
        _rating = 0;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Feedback submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() => _isSubmitting = false);
  }

  Widget _buildStarRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () => setState(() => _rating = index + 1),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            padding: EdgeInsets.all(5),
            child: Icon(
              Icons.star,
              color: index < _rating ? Colors.amber.shade700 : Colors.grey.shade400,
              size: 40,
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        toolbarHeight: 40,
        title: Text('Feedback', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white)),
        backgroundColor: Color(0xFF27445D),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 30,),
            Text(
              'We value your feedback!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),

            // Star Rating
            _buildStarRating(),
            SizedBox(height: 20),

            // Glassmorphism Feedback Box
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
                ],
              ),
              child: TextField(
                controller: _feedbackController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Your Feedback',
                  hintText: 'Type your feedback here...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF27445D), width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            SizedBox(height: 24),

            // Gradient Submit Button
            AnimatedContainer(
  duration: Duration(milliseconds: 300),
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [Color(0xFF27445D), Color(0xFF27445D)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
     
    ],
  ),
  child: ElevatedButton(
    onPressed: _isSubmitting ? null : _submitFeedback,
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
    ),
    child: _isSubmitting
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              ),
              SizedBox(width: 10),
              Text(
                'Submitting...',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold ,color: Colors.white),
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.send, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Submit Feedback',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600 , color: Colors.white),
              ),
            ],
          ),
  ),
),

          ],
        ),
      ),
    );
  }
}
