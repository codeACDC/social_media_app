import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app/bloc/app_cubit.dart';
import 'package:social_media_app/models/post_model.dart';
import 'package:social_media_app/screens/media_chats.dart';
import 'package:social_media_app/screens/media_post_screen.dart';
import 'dart:io';

import 'package:social_media_app/screens/sign_up_screen.dart';

class MediaPosts extends StatefulWidget {
  static const id = 'media_posts';

  const MediaPosts({Key? key}) : super(key: key);

  @override
  State<MediaPosts> createState() => _MediaPostsState();
}

class _MediaPostsState extends State<MediaPosts> {
  final Stream<QuerySnapshot> _postStream =
      FirebaseFirestore.instance.collection('posts').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                final picker = ImagePicker();
                picker
                    .pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 40,
                )
                    .then(
                  (value) {
                    if (value != null) {
                      final File file = File(value.path);
                      Navigator.of(context).pushNamed(
                        MediaPostScreen.id,
                        arguments: file,
                      );
                    }
                  },
                );
              },
              icon: const Icon(Icons.add)),
          IconButton(
              onPressed: () {
                context.read<MediaAppCubit>().signOut();
                    // .then((_) =>
                    // Navigator.of(context)
                    //     .pushReplacementNamed(SignUpScreen.id));
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _postStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error has occurred...'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.none) {
            return const Center(
              child: Text('Loading...'),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data?.docs.length ?? 0,
            itemBuilder: (context, index) {
              final QueryDocumentSnapshot _data = snapshot.data!.docs[index];
              final Post _post = Post(
                id: _data['postId'],
                userName: _data['userName'],
                imageUrl: _data['imageUrl'],
                description: _data['description'],
                timestamp: _data['timestamp'],
              );
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    MediaChats.id,
                    arguments: _post,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: NetworkImage(_post.imageUrl),
                              fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "User name: ${_post.userName}",
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Description: ${_post.description}",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      // const SizedBox(
                      //   height: 5,
                      // ),
                      // Text(
                      //   "Timestamp: ${_post.timestamp}",
                      //   style: Theme.of(context).textTheme.headline6,
                      // ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
