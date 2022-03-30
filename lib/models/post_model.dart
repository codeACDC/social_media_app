import 'package:cloud_firestore/cloud_firestore.dart';

class Post{
  final String id;
  final String userName;
  final String imageUrl;
  final String description;
  final Timestamp timestamp;

  const Post({
    required this.id,
    required this.userName,
    required this.imageUrl,
    required this.description,
    required this.timestamp,
});
}