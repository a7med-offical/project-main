import 'package:bldapp/Colors.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_application_5/constants.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _openAI = OpenAI.instance.build(
    token: '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',
    baseOption: HttpSetup(
      receiveTimeout: const Duration(seconds: 5),
    ),
    enableLog: true,
  );
  final ChatUser user = ChatUser(
    id: '1',
    firstName: 'Ahmed',
    lastName: 'Abd Elnasser',
  );
  final ChatUser assistant = ChatUser(
    id: '2',
    firstName: 'chat',
    lastName: 'gpt',
  );
  List<ChatMessage> chatMessages = <ChatMessage>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text(
          'Chat boy',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(0, 166, 126, 1),
      ),
      body: DashChat(
        
        messageOptions: const MessageOptions(
        
          currentUserContainerColor: Colors.green,
          containerColor: Color.fromRGBO(155, 166, 0, 1),
          textColor: Colors.white,
        ),
        currentUser: user,
        onSend: getChatResponse,
        messages: chatMessages,

        
      ),

    );
  }

  Future<void> getChatResponse(ChatMessage message) async {
    setState(() {
      chatMessages.insert(0, message);
    });

    if (message.text == "ليه مينفعش اتبرع") {
      final replyMessage1 = ChatMessage(
        user: assistant,
        createdAt: DateTime.now(),
        text: "اول ما  هيدوني المودل هقولك",
      );
      final replyMessage2 = ChatMessage(
        user: assistant,
        createdAt: DateTime.now(),
        text: "عايز حاجه تاني ي اخويا ولا اروح انام",
        customProperties:
            message.text == "I love u" ? {'color': Colors.grey} : null,
      );

      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        chatMessages.insert(0, replyMessage1);
      });

      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        chatMessages.insert(0, replyMessage2);
      });
    } else {
      List<Map<String, dynamic>> _messagesHistory =
          chatMessages.reversed.map((e) {
        if (e.user == user) {
          return {
            "role": "user",
            "content": e.text.toString(),
          };
        } else {
          return {
            "role": "assistant",
            "content": e.text.toString(),
          };
        }
      }).toList();
      final request = ChatCompleteText(
        model: GptTurbo0301ChatModel(),
        messages: _messagesHistory,
        // maxTokens: 200,
      );

      final response = await _openAI.onChatCompletion(request: request);

      for (var element in response!.choices) {
        if (element.message != null) {
          setState(() {
            chatMessages.insert(
              0,
              ChatMessage(
                user: assistant,
                createdAt: DateTime.now(),
                text: element.message!.content,
              ),
            );
          });
        }
      }
    }
  }
}
