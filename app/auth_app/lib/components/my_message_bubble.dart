import 'package:auth_app/components/my_message.dart';
import 'package:auth_app/models/message_model.dart';
import 'package:flutter/material.dart';

class MyMessageBubble extends StatelessWidget {
  const MyMessageBubble({super.key, required this.chatMessage, required this.isMe});

  final MessageModel chatMessage;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: <Widget> [
        Row(
          mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget> [
            Container(
              padding: const EdgeInsets.all(10),
              margin: isMe ? const EdgeInsets.only(right: 10) : const EdgeInsets.only(left: 10),
              width: 200,
              decoration: BoxDecoration(
                color: isMe ? Colors.blue : Colors.blue[800],
                borderRadius: BorderRadius.circular(10)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget> [
                  Text(
                    chatMessage.author,
                    style: const TextStyle(fontSize: 13, color: Colors.white),
                  ),
                  SizedBox(height: 5),
                  Text(
                    chatMessage.message,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  )
                ],
              ),
            )
          ],
        ),
        MyMessage(timestamp: chatMessage.timestamp)
      ],
    );
  }
}