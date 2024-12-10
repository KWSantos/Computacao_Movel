import 'package:flutter/material.dart';

class MyInputMessage extends StatelessWidget {
  const MyInputMessage({super.key, required this.handleSubmit, required this.messageController});

  final TextEditingController messageController;
  final Function(String message) handleSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: Row(
          children: <Widget> [
            Flexible(
              child: TextField(
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
                controller: messageController,
                cursorColor: Colors.black,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  contentPadding: EdgeInsets.all(20.0),
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Message',
                  hintStyle: TextStyle(color: Colors.white),
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black26),
                    borderRadius: BorderRadius.all(Radius.circular(60.0))
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(60.0))
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 5),
                    borderRadius: BorderRadius.all(Radius.circular(60.0)),
                    gapPadding: 8.0
                  )
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 4),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(30)
              ),
              child: IconButton(
                onPressed: () => handleSubmit(messageController.text),
                icon: const Icon(Icons.send_rounded),
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}