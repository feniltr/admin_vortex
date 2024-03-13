import 'package:admin/components/setTime.dart';
import 'package:admin/pages/Chat.dart';
import 'package:admin/pages/HomePage.dart';
import 'package:admin/pages/Manage.dart';
import 'package:admin/pages/bookings.dart';
import 'package:admin/pages/revenue.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0; // Index of the selected tab
  final List<Widget> _pages = [
    HomePage(),
    HistoryPage(),
    Revenue(),
    WallChat(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Vortex',
            style: GoogleFonts.pacifico(color: Colors.black),
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        leading: Icon(Icons.menu),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Sign out confirmation"),
                    content: Text("Want to sign out", style: TextStyle(fontSize: 18)),
                    actions: [
                      MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        color: Colors.deepPurple,
                      ),
                      MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                          FirebaseAuth.instance.signOut();
                        },
                        child: Text(
                          "Sign out",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        color: Colors.deepPurple,
                      )
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.logout, color: Colors.black),
          ),
        ],
      ),
      body: _pages[_currentIndex],

      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
        ]),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              gap: 8,
              activeColor: Colors.deepPurpleAccent,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              tabs: [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.book,
                  text: 'Bookings',
                ),
                GButton(
                  icon: Icons.attach_money,
                  text: 'Revenue',
                ),
                GButton(
                  icon: Icons.chat,
                  text: 'Chats',
                ),
              ],
              selectedIndex: _currentIndex,
              onTabChange: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
