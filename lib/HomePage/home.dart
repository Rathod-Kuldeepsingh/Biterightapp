//home navigation and divider drawer
import 'package:biterightapp/Articles/artcles.dart';
import 'package:biterightapp/AuthenticationPage/loginscreen.dart';
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
  final List<Widget> _pages = [BarcodeSearchScreen(), Artcles()];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.lightBlueAccent,
        title: Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            'BiteRight',
            style: GoogleFonts.hennyPenny(
              textStyle: const TextStyle(fontSize: 30, color: Colors.white),
            ),
          ),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              iconSize: 35,
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: _pages[_selectedIndex], // Display the selected page
      drawer: _buildDrawer(context),
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
  ],
  selectedItemColor: Colors.blueAccent,  // Color of selected item
  unselectedItemColor: Colors.grey,      // Color of unselected items
  backgroundColor: const Color.fromARGB(255, 236, 233, 233),         // Background color of the bottom nav
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
  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.lightBlueAccent,
            ),
            accountName: Text(
              _currentUser?.displayName ?? 'John Doe',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(
              _currentUser?.email ?? 'john.doe@example.com',
              style: const TextStyle(fontSize: 16),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                _currentUser?.displayName != null
                    ? _currentUser!.displayName![0].toUpperCase()
                    : _currentUser?.email?[0].toUpperCase() ?? 'U',
                style: const TextStyle(fontSize: 40.0, color: Colors.lightBlueAccent),
              ),
            ),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.home,
            title: 'Home',
            onTap: () {
              _navigateToHome();
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.settings,
            title: 'Settings',
            onTap: () {
              Navigator.pop(context);
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.logout,
            title: 'Logout',
            onTap: () => _confirmSignOut(context),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.settings,
            title: 'Feedback',
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Divider(),
          _buildDrawerItem(
            context,
            icon: Icons.help,
            title: 'Help & Support',
            onTap: () {
              Navigator.pop(context);
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.info,
            title: 'About Us',
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  // Drawer item builder
  ListTile _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      onTap: onTap,
    );
  }
}
