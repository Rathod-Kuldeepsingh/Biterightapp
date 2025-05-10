import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AllergySettingsScreen extends StatefulWidget {
  @override
  _AllergySettingsScreenState createState() => _AllergySettingsScreenState();
}

class _AllergySettingsScreenState extends State<AllergySettingsScreen> {
  final TextEditingController _allergyController = TextEditingController();
  List<String> allergies = [];

  @override
  void initState() {
    super.initState();
    _fetchAllergies();
  }

  void _fetchAllergies() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (doc.exists) {
      setState(() {
        allergies = List<String>.from(doc['allergies'] ?? []);
      });
    }
  }

  void _addAllergy() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    String allergy = _allergyController.text.trim();
    if (allergy.isNotEmpty && !allergies.contains(allergy)) {
      setState(() {
        allergies.add(allergy);
        _allergyController.clear();
      });

      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'allergies': allergies,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$allergy added to your allergies!')),
      );
    }
  }

  void _removeAllergy(String allergy) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    setState(() {
      allergies.remove(allergy);
    });

    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'allergies': allergies,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$allergy removed from your allergies!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Allergy Preferences',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
        backgroundColor: Color(0xFF27445D),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _allergyController,
              decoration: InputDecoration(
                labelText: "Enter Allergy",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: Icon(Icons.warning_amber_rounded, color: Colors.deepPurple),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _addAllergy,
                icon: Icon(Icons.add,color: Colors.white,),
                label: Text("Add Allergy",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold
                ),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF27445D),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: allergies.isEmpty
                  ? Center(
                      child: Text(
                        "No allergies added yet!",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: allergies.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Card(
                            elevation: 4,
                            margin: EdgeInsets.symmetric(vertical: 6),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              title: Text(
                                allergies[index],
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _removeAllergy(allergies[index]),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
