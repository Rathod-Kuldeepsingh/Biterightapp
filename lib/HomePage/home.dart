//home navigation and divider drawer
// ignore_for_file: use_build_context_synchronously, unused_element


import 'package:biterightapp/Articles/articals.dart';
import 'package:biterightapp/History/history.dart';
import 'package:biterightapp/MainPages/dash.dart';
import 'package:biterightapp/Profile/Profile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // User? _currentUser;

  // Pages for navigating content
  final List<Widget> _pages = [BarcodeSearchScreen(), FoodNewsScreen() ,HistoryPage(),UserProfileScreen()];

  // Index for the selected page in the bottom navigation bar
  int _selectedIndex = 0;

  // @override
  // void initState() {
  //   super.initState();
  //   _fetchUserDetails();
  // }

  // void _fetchUserDetails() {
  //   setState(() {
  //     _currentUser = FirebaseAuth.instance.currentUser;
  //   });
  // }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => FoodNewsScreen()), // Replace with your home page widget
    );
  }
    void _navigateToArticle() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => FoodNewsScreen()), // Replace with your home page widget
    );
  }
   void _navigateToHistory() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HistoryPage()), // Replace with your home page widget
    );
  }
Future<bool> _onWillPop() async {
  return await showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top illustration or icon
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.exit_to_app,
                size: 50,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            // Title
            Text(
              "Exit App?",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            // Description
            Text(
              "Are you sure you want to exit the app?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 20),
            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    foregroundColor:  Color(0xFF27445D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text("No"),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:  Color(0xFF27445D),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text("Yes"),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  ) ??
      false;
}

  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
      
        backgroundColor: Color(0xFFFFFCF2),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 50,
          backgroundColor: Color(0xFF27445D),
          title: Text(
              'BiteRight',
              style: GoogleFonts.hennyPenny(
                textStyle: const TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
          centerTitle: true,
         
          ),
        
        body: _pages[_selectedIndex], // Display the selected page
        // drawer: buildDrawer(context, _currentUser),
        bottomNavigationBar: BottomNavigationBar(
        
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
      BottomNavigationBarItem(
        icon: HugeIcon(icon: HugeIcons.strokeRoundedHome03, color: Colors.black,),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: HugeIcon(icon: HugeIcons.strokeRoundedNews, color: Colors.black,),
        label: 'Articles',
      ),
      BottomNavigationBarItem(
        icon:HugeIcon(icon: HugeIcons.strokeRoundedWorkHistory, color: Colors.black,),
        label: 'History',
      ),
       BottomNavigationBarItem(
        icon: HugeIcon(icon: HugeIcons.strokeRoundedProfile02, color: Colors.black,),
        label: 'Profile',
      ),
        ],
        selectedItemColor:Color(0xFF27445D),  // Color of selected item
        unselectedItemColor: Colors.black,      // Color of unselected items
              backgroundColor: Color(0xFFF5F5F5),
            // Background color of the bottom nav
        elevation: 8.0,                        // Adding elevation for shadow effect
        type: BottomNavigationBarType.fixed,   // For fixed size items
      ),
      
      
      ),
    );
  }

  // // Confirmation dialog before signing out
  // Future<void> _confirmSignOut(BuildContext context) async {
  //   bool confirm = await showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             backgroundColor: Colors.white,
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(16.0),
  //             ),
  //             title: Row(
  //               children: [
  //                 const Icon(Icons.warning_amber_rounded, color: Colors.red),
  //                 const SizedBox(width: 8),
  //                 const Text(
  //                   'Sign Out',
  //                   style: TextStyle(
  //                     fontWeight: FontWeight.bold,
  //                     fontSize: 20,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             content: const Text(
  //               'Are you sure you want to sign out?',
  //               style: TextStyle(
  //                 fontSize: 16,
  //                 color: Colors.black87,
  //               ),
  //             ),
  //             actionsAlignment: MainAxisAlignment.spaceEvenly,
  //             actions: [
  //               ElevatedButton(
  //                 onPressed: () => Navigator.of(context).pop(false),
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: Colors.grey[300],
  //                   foregroundColor: Colors.black87,
  //                   padding: const EdgeInsets.symmetric(
  //                       horizontal: 20, vertical: 12),
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(8.0),
  //                   ),
  //                 ),
  //                 child: const Text(
  //                   'Cancel',
  //                   style: TextStyle(fontSize: 16),
  //                 ),
  //               ),
  //               ElevatedButton(
  //                 onPressed: () => Navigator.of(context).pop(true),
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: Colors.redAccent,
  //                   foregroundColor: Colors.white,
  //                   padding: const EdgeInsets.symmetric(
  //                       horizontal: 24, vertical: 12),
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(8.0),
  //                   ),
  //                 ),
  //                 child: const Text(
  //                   'Sign Out',
  //                   style: TextStyle(fontSize: 16),
  //                 ),
  //               ),
  //             ],
  //           );
  //         },
  //       ) ??
  //       false;

  //   if (confirm) {
  //     signOutUser(context);
  //   }
  // }

  // // Sign-out function
  // Future<void> signOutUser(BuildContext context) async {
  //   try {
  //     await FirebaseAuth.instance.signOut();
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => LoginScreen()),
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Error signing out: ${e.toString()}'),
  //         duration: const Duration(seconds: 3),
  //       ),
  //     );
  //   }
  // }

  // Drawer with user details
  

// Drawer buildDrawer(BuildContext context, User? currentUser) {
//   return Drawer(
//     width: 300,
//     backgroundColor:Color(0xFFF5F5F5),
//     child: Column(
//       children: [
//         UserAccountsDrawerHeader(
//           decoration: const BoxDecoration(
//            color:  Color(0xFF27445D)
//           ),
//           accountName: Text(
//             currentUser?.displayName ?? 'John Doe',
//             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
//           ),
//           accountEmail: Text(
//             currentUser?.email ?? 'john.doe@example.com',
//             style: const TextStyle(fontSize: 16,  color: Colors.white),
//           ),
//           currentAccountPicture: CircleAvatar(
//             backgroundColor: Color(0xFFF5F5F5),
//             radius: 30,
//             child: Text(
//               currentUser?.displayName != null
//                   ? currentUser!.displayName![0].toUpperCase()
//                   : currentUser?.email?[0].toUpperCase() ?? 'U',
//               style: const TextStyle(fontSize: 40.0, color:  Color(0xFF27445D)),
//             ),
//           ),
//         ),
//         Expanded(
//           child: ListView(
//             padding: const EdgeInsets.symmetric(vertical: 8),
//             children: [
//               _buildDrawerItem(
//                 context,
//                 icon: Icons.home,
//                 title: 'Home',
//                    iconColor: Color(0xFF27445D),
//                 onTap: () =>     Navigator.pushNamed(context, "/home"),
//               ),
//               // _buildDrawerItem(
//               //   context,
//               //   icon: Icons.article_rounded,
//               //   iconColor: Color.fromRGBO(7, 94, 84, 1.0),oreo
//               //   title: 'Articles',
//               //   onTap: () => Navigator.pop(context),
//               // ),
//               //  _buildDrawerItem(
//               //   context,
//               //   icon: Icons.history,
//               //   title: 'History',
//               //   onTap: () => Navigator.pop(context),
//               //      iconColor: Color.fromRGBO(7, 94, 84, 1.0),
//               // ),
//               _buildDrawerItem(
//                 context,
//                 icon: Icons.settings,
//                 title: 'Settings',
//                 onTap: () => Navigator.pop(context),
//                    iconColor:  Color(0xFF27445D),
//               ),
//               _buildDrawerItem(
//                 context,
//                 icon: Icons.feedback,
//                 title: 'Feedback',
//                 onTap: () => Navigator.pop(context),
//                    iconColor:  Color(0xFF27445D),
//               ),
              
//               _buildDrawerItem(
//                 context,
//                 icon: Icons.logout,
//                 title: 'Logout',
//                 onTap: () => _confirmSignOut(context),
//                 iconColor: Colors.redAccent, // Highlight logout button
//               ),
//               const Divider(thickness: 1, indent: 16, endIndent: 16),
//               _buildDrawerItem(
//                 context,
//                 icon: Icons.help_outline,
//                 title: 'Help & Support',
//                    iconColor: Color(0xFF27445D),
//                 onTap: () => Navigator.pop(context),
//               ),
//               _buildDrawerItem(
//                 context,
//                 icon: Icons.info_outline,
//                 title: 'About Us',
//                    iconColor: Color(0xFF27445D),
//                 onTap: () => Navigator.pop(context),
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }

// // Reusable Drawer Item with Better Styling
// Widget _buildDrawerItem(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap, Color? iconColor}) {
//   return ListTile(
//     leading: Icon(icon, color: iconColor ?? Colors.blueGrey, size: 26),
//     title: Text(
//       title,
//       style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//     ),
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//     onTap: onTap,
//     contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
//     hoverColor: Colors.blue[50], // Subtle hover effect
//   );
// }
// }
}
