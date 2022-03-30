// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/models/chat_model.dart';
import 'package:social_media_app/models/post_model.dart';
import 'package:social_media_app/widgets/message_widget.dart';

class MediaChats extends StatefulWidget {
  const MediaChats({Key? key}) : super(key: key);

  static const String id = 'media_chats';

  @override
  State<MediaChats> createState() => _MediaChatsState();
}

class _MediaChatsState extends State<MediaChats> {
  String _message = '';
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }

  final _currentUserId = FirebaseAuth.instance.currentUser!.uid;

  void _submit(Post post) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(post.id)
        .collection('comments')
        .add({
          'userId': FirebaseAuth.instance.currentUser!.uid,
          'userName': FirebaseAuth.instance.currentUser!.displayName,
          'message': _message,
          'timestamp': Timestamp.now(),
        })
        .then((value) => print('Chat doc added!'))
        .catchError(
            (onError) => print('An error has occurred! Chat doc added error!'));

    setState(() {
      _message = '';
    });

    _textEditingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final Post _post = ModalRoute.of(context)!.settings.arguments as Post;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .doc(_post.id)
                    .collection('comments')
                    .orderBy('timestamp')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('An error has occurred!'),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      snapshot.connectionState == ConnectionState.none) {
                    return const Center(
                      child: Text('Loading...'),
                    );
                  }
                  return GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: ListView.builder(
                      itemCount: snapshot.data?.docs.length ?? 0,
                      itemBuilder: (context, index) {
                        final QueryDocumentSnapshot _data =
                            snapshot.data!.docs[index];
                        final Chat _chat = Chat(
                            message: _data['message'],
                            userId: _data['userId'],
                            userName: _data['userName'],
                            timestamp: _data['timestamp']);
                        return Align(
                            alignment: _chat.userId == _currentUserId
                                ? Alignment.topRight
                                : Alignment.topLeft,
                            child: MessageWidget(_chat));
                      },
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: TextField(
                        maxLines: 2,
                        textInputAction: TextInputAction.done,
                        controller: _textEditingController,
                        decoration: InputDecoration(
                          hintText: 'Enter message',
                          enabledBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.deepPurple,
                            ),
                          ),
                          disabledBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.deepPurple,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          _message = value;
                        },
                        onEditingComplete: () {
                          _submit(_post);
                        },
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _submit(_post);
                    },
                    icon: const Icon(Icons.arrow_forward_ios),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
