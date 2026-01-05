import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../../constants.dart';
import '../../../../../core/utils/styles.dart';
import '../home_view.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> cachedChats = [];

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.sizeOf(context).width * 0.8;
    var user = auth.currentUser;

    return Drawer(
      width: width,
      child: Container(
        decoration: const BoxDecoration(gradient: kBackgroundColor),
        child: Column(
          children: [
            _buildDrawerHeader(),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
            stream: firestore
                .collection('messages')
                .where('userId', isEqualTo: user!.uid)
                .orderBy('createdAt', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.builder(
              itemCount: cachedChats.length,
              itemBuilder: (context, index) {
                var chat = cachedChats[index];
                return _buildDrawerTile(
                  title: chat['title'] ?? "Chat ${index + 1}",
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeView(chatId: chat['id']),
                      ),
                    );
                  },
                );
              },
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          var docs = snapshot.data?.docs ?? [];
          if (docs.isNotEmpty) {
            cachedChats = docs
                .map((doc) => {"id": doc.id, "title": doc['title']})
                .toList();
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var chat = docs[index];
              var chatTitle = chat['title'] ?? "Chat ${index + 1}";
              return _buildDrawerTile(
                title: chatTitle,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeView(chatId: chat.id),
                    ),
                  );
                },
              );
            },
          );
        },
      )
    ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return DrawerHeader(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Image.asset(kLogo, height: 50, width: 100),
          const SizedBox(height: 10),
          Text(
            'Chats History',
            style: Styles.fontStyle26.copyWith(fontSize: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerTile({required String title, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(style: BorderStyle.solid, color: Colors.white),
        ),
        child: ListTile(
          title: Text(
            title,
            style: Styles.fontStyle26.copyWith(fontSize: 18),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}

