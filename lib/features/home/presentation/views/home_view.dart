import 'package:chat_with_gemini/constants.dart';
import 'package:chat_with_gemini/features/home/presentation/views/widgets/intial_body.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/app_router.dart';
import 'widgets/app_drawer.dart';
import 'widgets/successful_response_body.dart';

class HomeView extends StatefulWidget {
  final String? chatId;
  const HomeView({super.key, this.chatId});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Map<String, dynamic>> chatHistory = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.chatId != null) {
      _loadChatHistory(widget.chatId!);
    } else {
      setState(() => isLoading = false);
    }
  }

  Future<void> _loadChatHistory(String chatId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final chatDoc = await FirebaseFirestore.instance
        .collection('messages')
        .doc(chatId)
        .get();

    if (chatDoc.exists && chatDoc.data()?['userId'] == user.uid) {
      final chatDocs = await FirebaseFirestore.instance
          .collection('messages')
          .doc(chatId)
          .collection('chats')
          .orderBy('timestamp', descending: false)
          .get();

      if (mounted) {
        setState(() {
          if (chatDocs.docs.isNotEmpty) {
            chatHistory = chatDocs.docs.map((doc) => doc.data()).toList();
          }
          isLoading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff222222),
        title: Image.asset(kLogo, height: 50, width: 100),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed:(){
                GoRouter.of(context).pushReplacement(AppRouter.kProfileView);
              },
              icon: Icon(FontAwesomeIcons.user)
          )
        ],
      ),
      body: isLoading
          ? InitialBody()
          : SuccessfulResponseBody(chatHistory: chatHistory),
    );
  }
}
