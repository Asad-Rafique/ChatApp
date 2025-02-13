import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../chat_screen.dart';

class UsersTab extends StatelessWidget {
  const UsersTab({super.key});

  Future<void> _createChat(BuildContext context, String otherUserId,
      String otherUserEmail, String otherUserName) async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final chatId = [currentUserId, otherUserId]..sort();

    await FirebaseFirestore.instance
        .collection('chat_participants')
        .doc(chatId.join('_'))
        .set({
      'users': chatId,
      'created_at': FieldValue.serverTimestamp(),
      'last_message': '',
      'last_message_time': FieldValue.serverTimestamp(),
    });

    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChatScreen(
            chatId: chatId.join('_'),
            otherUserEmail: otherUserEmail,
            otherUserName: otherUserName,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .orderBy('name')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final users = snapshot.data!.docs;
        final currentUserId = FirebaseAuth.instance.currentUser!.uid;

        if (users.isEmpty) {
          return const Center(
            child: Text(
              'No users found',
              style: TextStyle(
                color: Color(0xFF6B4E71),
                fontSize: 16,
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            if (user.id == currentUserId) return const SizedBox.shrink();

            final name = user['name'] ?? 'Unknown';
            final email = user['email'] ?? '';

            return Card(
              elevation: 0,
              color: Colors.white.withOpacity(0.9),
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFF9747FF),
                  child: Text(
                    name[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6B4E71),
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  email,
                  style: TextStyle(
                    color: const Color(0xFF6B4E71).withOpacity(0.7),
                  ),
                ),
                trailing: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF9747FF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: const Text(
                    'Message',
                    style: TextStyle(
                      color: Color(0xFF9747FF),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                onTap: () => _createChat(
                  context,
                  user.id,
                  email,
                  name,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
