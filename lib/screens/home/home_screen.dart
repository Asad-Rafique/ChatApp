import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'tabs/users_tab.dart';
import 'tabs/chats_tab.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Chatting',
            style: TextStyle(
              color: Color(0xFF6B4E71),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: Color(0xFF6B4E71)),
              onPressed: () => FirebaseAuth.instance.signOut(),
            ),
          ],
          backgroundColor: const Color(0xFFFCE7F3),
          elevation: 0,
          bottom: const TabBar(
            tabs: [
              Tab(
                child: Text(
                  'All Users',
                  style: TextStyle(
                    color: Color(0xFF6B4E71),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Chats',
                  style: TextStyle(
                    color: Color(0xFF6B4E71),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
            indicatorColor: Color(0xFF9747FF),
            indicatorWeight: 3,
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFCE7F3), // Light pink
                Color(0xFFF3E8FF), // Light purple
              ],
            ),
          ),
          child: const TabBarView(
            children: [
              UsersTab(),
              ChatsTab(),
            ],
          ),
        ),
      ),
    );
  }
}
