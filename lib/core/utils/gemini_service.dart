import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../constants.dart';

class GeminiServices {

  final gemini = GenerativeModel(
    model: 'gemini-2.0-flash',
    apiKey: kApiKey,
  );

  Future<String> generateChatTitle(List<Map<String, dynamic>> chatHistory) async {
    String endpoint = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$kApiKey";

    // Extract first few messages for title generation
    String conversationSummary = chatHistory.take(3).map((m) => m['message']).join(" ");

    var response = await http.post(
      Uri.parse(endpoint),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {
                "text": "Generate a short, meaningful title (max 4 words) based on this conversation without any explanation just the first title in the form of plain text: \"$conversationSummary\"."
              }
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      // Extract the title correctly from the response
      String? title = data['candidates']?[0]['content']?['parts']?[0]['text'];

      if (title != null && title.isNotEmpty) {
        return title.trim();
      }
    }

    return "New Chat"; // Fallback title
  }

}