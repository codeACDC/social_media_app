import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class MediaPostScreen extends StatefulWidget {
  const MediaPostScreen({Key? key}) : super(key: key);
  static const id = 'media_post_screen';

  @override
  State<MediaPostScreen> createState() => _MediaPostScreenState();
}

class _MediaPostScreenState extends State<MediaPostScreen> {
  String _description = '';

  Future<void> _submit({required File file}) async {
    if (_description.trim().isNotEmpty) {
      try {
        late String imageUrl;
        firebase_storage.FirebaseStorage storage =
            firebase_storage.FirebaseStorage.instance;
        await storage
            .ref('images/${UniqueKey().toString()}${file.path.split('/').last}')
            .putFile(file)
            .then(
          (value) async {
            imageUrl = await value.ref.getDownloadURL();
          },
        );

        FirebaseFirestore.instance.collection('posts').add({
          'timestamp': Timestamp.now(),
          'userId': FirebaseAuth.instance.currentUser!.uid,
          'description': _description,
          'userName': FirebaseAuth.instance.currentUser!.displayName,
          'imageUrl': imageUrl,
        }).then((docRef) => docRef.update({'postId': docRef.id}));
        Navigator.of(context).pop();
      } on firebase_core.FirebaseException catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error.toString(),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
        Navigator.of(context).pop();
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Oops wait one more second...',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final File imageFile = ModalRoute.of(context)!.settings.arguments as File;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create post'),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width / 1.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: FileImage(imageFile), fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  autofocus: true,
                  inputFormatters: [LengthLimitingTextInputFormatter(181)],
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    hintText: 'Enter description of post...',
                    disabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black54),
                    ),
                  ),
                  maxLength: 181,
                  onChanged: (value) {
                    _description = value;
                  },
                  onEditingComplete: () {
                    _submit(file: imageFile);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
