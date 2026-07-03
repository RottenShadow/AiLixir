import 'package:ailixir/features/chatbot/presentation/widgets/chatbot_textbox.dart';

class ThreadMessageModel {
  final String title;
  final List<MessageModel> messages;
  ThreadMessageModel({required this.title, required this.messages});
  ThreadMessageModel.fromJson(Map<String, dynamic> json)
    : this(
        title: json["data"]["title"],
        messages: List.generate(json["data"]["messages"].length, (idx) {
          return MessageModel.fromJson(json["data"]["messages"][idx]);
        }),
      );

  List<ChatbotTextbox> toMessages() {
    List<ChatbotTextbox> chatHistory = [];
    for (MessageModel m in messages) {
      chatHistory.add(
        ChatbotTextbox(
          isNotSearched: false,
          isBot: false,
          text: m.input_data,
          onBufferFilled: () {},
        ),
      );
      chatHistory.add(
        ChatbotTextbox(
          isNotSearched: false,
          isBot: true,
          isError: !m.status,
          text: m.status ? m.response : "",
          onBufferFilled: () {},
        ),
      );
    }
    return chatHistory;
  }
}

class MessageModel {
  final int id;
  final String input_data;
  final String response;
  final bool status;
  const MessageModel({
    required this.id,
    required this.input_data,
    required this.response,
    required this.status,
  });
  MessageModel.fromJson(Map<String, dynamic> json)
    : this(
        id: json["id"],
        input_data: json["input_data"],
        response: json["response"],
        status: json["status"] == "success",
      );
}
