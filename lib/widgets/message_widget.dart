import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/models/chat_model.dart';

class MessageWidget extends StatelessWidget {
  final Chat _chat;

  MessageWidget(this._chat, {Key? key}) : super(key: key);
  final _currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 21),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(15),
            topRight: const Radius.circular(15),
            bottomLeft: _currentUserId == _chat.userId
                ? const Radius.circular(15)
                : Radius.zero,
            bottomRight: _currentUserId == _chat.userId
                ? Radius.zero
                : const Radius.circular(15),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: _currentUserId == _chat.userId
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'By ${_chat.userName}',
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 5),
              Text(
                _chat.message,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
