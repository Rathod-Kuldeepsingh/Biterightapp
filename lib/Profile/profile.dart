// ignore_for_file: use_build_context_synchronously

import 'package:biterightapp/AuthenticationPage/loginscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  User? _currentUser;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  void _fetchUserDetails() {
    setState(() {
      _currentUser = FirebaseAuth.instance.currentUser;
      _nameController.text = _currentUser?.displayName ?? '';
    });
  }

Future<void> _editProfile() {
  _nameController.text = _currentUser?.displayName ?? '';

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            SizedBox(width: 8),
            Text(
              'Edit Profile',
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF27445D), width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey[700],
            ),
            child: Text(
              'Cancel',
              style: TextStyle(fontSize: 16),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              try {
                await _currentUser?.updateDisplayName(_nameController.text);
                _fetchUserDetails();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Profile updated successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: ${e.toString()}'),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            },
            icon: Icon(Icons.save, color: Colors.white),
            label: Text('Save'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF27445D),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
            ),
          ),
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFF5F5F5),
        body: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: Color(0xFF27445D),
                      radius: 50,
                      child: Text(
                        _currentUser?.displayName?.isNotEmpty == true
                            ? _currentUser!.displayName![0].toUpperCase()
                            : _currentUser?.email?[0].toUpperCase() ?? 'U',
                        style: const TextStyle(
                            fontSize: 40.0, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _currentUser?.displayName ?? 'John Doe',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _currentUser?.email ?? 'john.doe@example.com',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton.icon(
                      onPressed: _editProfile,
                      icon: Icon(Icons.edit, color: Colors.white),
                      label: Text(
                        'Edit Profile',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF27445D), // Primary color
                        foregroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3, // Adds a slight shadow for depth
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Profile Options
              _buildProfileOption(
                context,
                icon: Icons.settings,
                title: 'Settings',
                onTap: () => Navigator.pushNamed(context, "/settings"),
              ),
              _buildProfileOption(
                context,
                icon: Icons.feedback,
                title: 'Feedback',
                onTap: () => Navigator.pushNamed(context, "/feedback"),
              ),
              _buildProfileOption(
                context,
                icon: Icons.help_outline,
                title: 'Help & Support',
                onTap: () => Navigator.pushNamed(context, "/help"),
              ),
              _buildProfileOption(
                context,
                icon: Icons.info_outline,
                title: 'About Us',
                onTap: () => Navigator.pushNamed(context, "/about"),
              ),

              const Divider(thickness: 1, height: 30),

              _buildProfileOption(
                context,
                icon: Icons.logout,
                title: 'Logout',
                iconColor: Colors.redAccent,
                onTap: () => _confirmSignOut(context),
              ),
            ],
          ),
        ));
  }
}

Widget _buildProfileOption(BuildContext context,
    {required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor}) {
  return ListTile(
    leading: Icon(icon, color: iconColor ?? Colors.black87, size: 26),
    title: Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    onTap: onTap,
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    hoverColor: Colors.blue[50], // Subtle hover effect
  );
}

Future<void> _confirmSignOut(BuildContext context) async {
  bool confirm = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            title: Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: Colors.red),
                const SizedBox(width: 8),
                const Text(
                  'Sign Out',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            content: const Text(
              'Are you sure you want to sign out?',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.black87,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text('Cancel', style: TextStyle(fontSize: 16)),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text('Sign Out', style: TextStyle(fontSize: 16)),
              ),
            ],
          );
        },
      ) ??
      false;

  if (confirm) {
    signOutUser(context);
  }
}

Future<void> signOutUser(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error signing out: ${e.toString()}'),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
