import 'package:chat_with_gemini/core/utils/gemini_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../../../../constants.dart';
import '../../../../../core/utils/styles.dart';
import '../../manager/home_view_cubit/home_cubit.dart';
import '../../manager/home_view_cubit/home_states.dart';
import 'chat_message_widget.dart';

class SuccessfulResponseBody extends StatefulWidget {
  const SuccessfulResponseBody({super.key, required this.chatHistory});
  final List<Map<String, dynamic>> chatHistory;

  @override
  State<SuccessfulResponseBody> createState() => _SuccessfulResponseBodyState();
}

class _SuccessfulResponseBodyState extends State<SuccessfulResponseBody> {

  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference messages = FirebaseFirestore.instance.collection('messages');
  late final ChatSession chatSession;
  bool isLoading = false;
  List<Map<String, dynamic>> chatHistory = [];
  String? chatId;

  @override
  void initState() {
    super.initState();
    chatSession = GeminiServices().gemini.startChat();
    chatHistory = List.from(widget.chatHistory);

    if (widget.chatHistory.isNotEmpty) {
      chatId = widget.chatHistory.first['chatId']; // Use existing chat ID if available
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
          gradient: kBackgroundColor
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: BlocBuilder<HomeCubit, HomeStates>(
                builder: (context, state) => ListView.builder(
                  controller: scrollController,
                  itemCount: chatHistory.length,
                  itemBuilder: (context, index) {
                    final messageData = chatHistory[index];
                    final message = messageData['message'];
                    final isUser = messageData['isUser'];
                    return isUser
                        ? ChatBubble(message: message)
                        : ChatBubbleGemini(message: message);
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: textController,
              style: Styles.fontStyle26.copyWith(color: Colors.white, fontSize: 18),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(30),
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    sendMessage(message: textController.text);
                    setState(() {
                    });
                    scrollDown();
                  },
                  icon: const Icon(Icons.send_rounded, color: Colors.white),
                ),
                label: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Talk to Gemini',
                    style: Styles.fontStyle26.copyWith(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> sendMessage({required String message}) async {
    if (message.trim().isEmpty) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      debugPrint("User not logged in");
      return;
    }

    setState(() {
      isLoading = true;
      chatHistory.add({'message': message, 'isUser': true});
    });

    textController.clear();
    scrollDown();

    try {
      String botMessage = '';
      setState(() {
        chatHistory.add({'message': botMessage, 'isUser': false}); // Placeholder for streaming
      });

      await for (final response in chatSession.sendMessageStream(Content.text(message))) {
        if (response.text != null) {
          setState(() {
            botMessage += response.text!;
            chatHistory.last['message'] = botMessage; // Update UI in real-time
          });
          scrollDown();
        }
      }

      // Generate chat title (only for new chats)
      String chatTitle = await GeminiServices().generateChatTitle(chatHistory);

      // Check if it's a new chat or an existing one
      if (chatId == null) {
        final newChat = await messages.add({
          'title': chatTitle,
          'createdAt': FieldValue.serverTimestamp(),
          'userId': user.uid, // Store user ID
        });
        chatId = newChat.id;
      }

      // Save user message
      await messages.doc(chatId).collection('chats').add({
        'message': message,
        'isUser': true,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Save bot response
      await messages.doc(chatId).collection('chats').add({
        'message': botMessage,
        'isUser': false,
        'timestamp': FieldValue.serverTimestamp(),
      });

    } catch (e) {
      debugPrint('Error sending message: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
      scrollDown();
    }
  }

  void scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

}
