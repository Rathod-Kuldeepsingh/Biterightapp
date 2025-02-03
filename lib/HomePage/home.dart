//home navigation and divider drawer
// ignore_for_file: use_build_context_synchronously, unused_element

import 'package:biterightapp/Articles/artcles.dart';
import 'package:biterightapp/AuthenticationPage/loginscreen.dart';
import 'package:biterightapp/History/history.dart';
import 'package:biterightapp/MainPages/dash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  User? _currentUser;

  // Pages for navigating content
  final List<Widget> _pages = [BarcodeSearchScreen(), ArticlePage() ,HistoryPage()];

  // Index for the selected page in the bottom navigation bar
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  void _fetchUserDetails() {
    setState(() {
      _currentUser = FirebaseAuth.instance.currentUser;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => BarcodeSearchScreen()), // Replace with your home page widget
    );
  }
    void _navigateToArticle() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ArticlePage()), // Replace with your home page widget
    );
  }
   void _navigateToHistory() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HistoryPage()), // Replace with your home page widget
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Color(0xFFFFFCF2),
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Color(0xFFFFFCF2),
        title: Text(
            'BiteRight',
            style: GoogleFonts.hennyPenny(
              textStyle: const TextStyle(fontSize: 30, color: Color.fromRGBO(7, 94, 84, 1.0)),
            ),
          ),
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.only(top: 8,bottom: 8,right: 0,left: 5),
              child: IconButton(
                icon: const Icon(Icons.menu, color: Color.fromRGBO(7, 94, 84, 1.0)),
                iconSize: 35,
                style: ButtonStyle(
                 backgroundColor: WidgetStateProperty.all(Color(0xFFFFFCF2)),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Rounded button
                ),
              ),
              elevation: WidgetStateProperty.all(4), // Add shadow
                        
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            );
          },
        ),
      ),
      body: _pages[_selectedIndex], // Display the selected page
      drawer: buildDrawer(context, _currentUser),
      bottomNavigationBar: BottomNavigationBar(
  
  currentIndex: _selectedIndex,
  onTap: _onItemTapped,
  items: const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home,size: 30,),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.article,size: 30,),
      label: 'Articles',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.history,size: 30,),
      label: 'History',
    )
  ],
  selectedItemColor: Color.fromRGBO(7, 94, 84, 1.0),  // Color of selected item
  unselectedItemColor: Colors.black,      // Color of unselected items
            backgroundColor: Color(0xFFF5F5F5),
          // Background color of the bottom nav
  elevation: 8.0,                        // Adding elevation for shadow effect
  type: BottomNavigationBarType.fixed,   // For fixed size items
),


    );
  }

  // Confirmation dialog before signing out
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Sign Out',
                    style: TextStyle(fontSize: 16),
                  ),
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

  // Sign-out function
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

  // Drawer with user details
  

Drawer buildDrawer(BuildContext context, User? currentUser) {
  return Drawer(
    width: 300,
    backgroundColor:Color(0xFFF5F5F5),
    child: Column(
      children: [
        UserAccountsDrawerHeader(
          decoration: const BoxDecoration(
           color: Color(0xFFFFFCF2)
          ),
          accountName: Text(
            currentUser?.displayName ?? 'John Doe',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          accountEmail: Text(
            currentUser?.email ?? 'john.doe@example.com',
            style: const TextStyle(fontSize: 16,  color: Colors.black),
          ),
          currentAccountPicture: CircleAvatar(
            backgroundColor: Color(0xFFF5F5F5),
            radius: 30,
            child: Text(
              currentUser?.displayName != null
                  ? currentUser!.displayName![0].toUpperCase()
                  : currentUser?.email?[0].toUpperCase() ?? 'U',
              style: const TextStyle(fontSize: 40.0, color: Color.fromRGBO(7, 94, 84, 1.0)),
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              _buildDrawerItem(
                context,
                icon: Icons.home,
                title: 'Home',
                   iconColor: Color.fromRGBO(7, 94, 84, 1.0),
                onTap: () => _navigateToHome(),
              ),
              _buildDrawerItem(
                context,
                icon: Icons.article_rounded,
                iconColor: Color.fromRGBO(7, 94, 84, 1.0),
                title: 'Articles',
                onTap: () => _navigateToHome(),
              ),
               _buildDrawerItem(
                context,
                icon: Icons.history,
                title: 'History',
                onTap: () => Navigator.pop(context),
                   iconColor: Color.fromRGBO(7, 94, 84, 1.0),
              ),
              _buildDrawerItem(
                context,
                icon: Icons.settings,
                title: 'Settings',
                onTap: () => Navigator.pop(context),
                   iconColor: Color.fromRGBO(7, 94, 84, 1.0),
              ),
              _buildDrawerItem(
                context,
                icon: Icons.feedback,
                title: 'Feedback',
                onTap: () => Navigator.pop(context),
                   iconColor: Color.fromRGBO(7, 94, 84, 1.0),
              ),
              
              _buildDrawerItem(
                context,
                icon: Icons.logout,
                title: 'Logout',
                onTap: () => _confirmSignOut(context),
                iconColor: Colors.redAccent, // Highlight logout button
              ),
              const Divider(thickness: 1, indent: 16, endIndent: 16),
              _buildDrawerItem(
                context,
                icon: Icons.help_outline,
                title: 'Help & Support',
                   iconColor: Color.fromRGBO(7, 94, 84, 1.0),
                onTap: () => Navigator.pop(context),
              ),
              _buildDrawerItem(
                context,
                icon: Icons.info_outline,
                title: 'About Us',
                   iconColor: Color.fromRGBO(7, 94, 84, 1.0),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// Reusable Drawer Item with Better Styling
Widget _buildDrawerItem(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap, Color? iconColor}) {
  return ListTile(
    leading: Icon(icon, color: iconColor ?? Colors.blueGrey, size: 26),
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
}
