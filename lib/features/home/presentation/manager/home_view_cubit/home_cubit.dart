import 'package:chat_with_gemini/features/home/presentation/manager/home_view_cubit/home_states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../../../../../core/utils/gemini_service.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(InitialHomeState());

  String? chatId;
  final GeminiServices geminiServices = GeminiServices();
  final ChatSession chatSession = GeminiServices().gemini.startChat();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference messages = FirebaseFirestore.instance.collection('messages');
  List<Map<String, dynamic>> chatHistory = [];
  TextEditingController textController = TextEditingController();

  Function()? scrollToBottom; // Scroll callback

  /// 🔄 Load chat history from Firestore
  Future<void> loadChat(String? chatId) async {
    if (chatId == null) {
      emit(InitialHomeState());
      return;
    }
    try {
      var doc = await firestore.collection('messages').doc(chatId).get();
      if (doc.exists && doc.data() != null) {
        chatHistory = List<Map<String, dynamic>>.from(doc.data()?['chatHistory'] ?? []);
        emit(SuccessfulResponseState(List.from(chatHistory)));
      } else {
        emit(InitialHomeState());
      }
    } catch (e) {
      emit(FailureResponseState("Failed to load chat: $e"));
    }
  }

  /// ✉️ **Send Message with Gemini Response**
  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    // 🟢 1. Add user's message to chat history
    chatHistory.add({'message': message, 'isUser': true});
    emit(SuccessfulResponseState(List.from(chatHistory)));

    // 🟢 2. Prepare for bot response
    StringBuffer responseBuffer = StringBuffer();
    chatHistory.add({'message': '', 'isUser': false}); // Placeholder for bot response
    emit(SuccessfulResponseState(List.from(chatHistory)));

    try {
      // 🟢 3. Stream Gemini's response and update UI incrementally
      await for (final response in chatSession.sendMessageStream(Content.text(message))) {
        final text = response.text;
        if (text != null) {
          responseBuffer.write(text);
          chatHistory.last['message'] = responseBuffer.toString();
          emit(SuccessfulResponseState(List.from(chatHistory)));
          scrollToBottom?.call(); // ⬇️ Scroll down as text is received
        }
      }

      // 🟢 4. Generate a chat title if it's a new conversation
      String chatTitle = "New Chat";
      if (chatHistory.length == 2) {
        final titleResponse = await chatSession.sendMessage(Content.text(
            "Generate one short title for this conversation from max four words without any explanation or description just a plain text: \"$message\""
        ));
        chatTitle = titleResponse.text?.trim() ?? "New Chat";
      }

      // 🟢 5. Save or update chat in Firestore
      if (chatId == null) {
        DocumentReference newChat = await firestore.collection('messages').add({
          'timestamp': FieldValue.serverTimestamp(),
          'chatHistory': List.from(chatHistory),
          'title': chatTitle,
        });
        chatId = newChat.id;
      } else {
        await firestore.collection('messages').doc(chatId).update({
          'chatHistory': List.from(chatHistory),
        });
      }

      scrollToBottom?.call(); // ⬇️ Final scroll after response is fully received

    } catch (e) {
      emit(FailureResponseState("Failed to send message: $e"));
    }
  }
}
