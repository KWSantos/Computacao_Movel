import 'package:auth_app/components/my_input_message.dart';
import 'package:auth_app/components/my_message_bubble.dart';
import 'package:auth_app/providers/chat_prodiver.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:auth_app/models/message_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatPage extends StatefulWidget {
  final String chatId;
  final String chatName;

  const ChatPage({
    super.key,
    required this.chatId,
    required this.chatName,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatProvider chatProvider = ChatProvider(firebaseFirestore: FirebaseFirestore.instance);
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final user = FirebaseAuth.instance.currentUser!;

  void sendMessage(String message) {
    if (message.isNotEmpty) {
      messageController.clear();
      chatProvider.sendMessage(
        chatId: widget.chatId,
        message: message.trim(),
        author: user.email ?? 'Anônimo',
      );
      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Widget _buildItem(QueryDocumentSnapshot<Map<String, dynamic>>? documentSnapshot) {
    if (documentSnapshot != null) {
      final chatMessage = MessageModel.fromDocument(documentSnapshot);
      final isMe = chatMessage.author == user.email;

      return MyMessageBubble(chatMessage: chatMessage, isMe: isMe);
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue[800],
        elevation: 1,
        title: Text(widget.chatName, style: const TextStyle(fontSize: 16)),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Flexible(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: chatProvider.getChatMessages(widget.chatId),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                    if (snapshot.hasData) {
                      final messageList = snapshot.data!.docs;

                      if (messageList.isNotEmpty) {
                        return ListView.builder(
                          padding: const EdgeInsets.all(10),
                          itemCount: messageList.length,
                          reverse: true,
                          controller: scrollController,
                          itemBuilder: (context, index) => _buildItem(messageList[index]),
                        );
                      } else {
                        return const Center(
                          child: Text(
                            'Sem mensagens',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 20,
                            ),
                          ),
                        );
                      }
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          'Erro ao carregar mensagens',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                          ),
                        ),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.blue,
                        ),
                      );
                    }
                  },
                ),
              ),
              MyInputMessage(
                messageController: messageController,
                handleSubmit: sendMessage,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
