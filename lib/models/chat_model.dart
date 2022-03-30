import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String message;
  final String userId;
  final String userName;
  final Timestamp timestamp;

  const Chat({
    required this.message,
    required this.userId,
    required this.userName,
    required this.timestamp,
});
}