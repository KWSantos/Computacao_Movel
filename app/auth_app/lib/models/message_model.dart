// Updated MessageModel
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String author;
  final String message;
  final DateTime timestamp;

  MessageModel({
    required this.author,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'author': author,
      'message': message,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  factory MessageModel.fromDocument(DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    final data = documentSnapshot.data();
    if (data == null) {
      throw Exception('Documento vazio ou inválido: ${documentSnapshot.id}');
    }

    return MessageModel(
      author: data['author'] ?? 'Anônimo',
      message: data['message'] ?? '',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      author: json['author'] ?? 'Anônimo',
      message: json['message'] ?? '',
      timestamp: (json['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}