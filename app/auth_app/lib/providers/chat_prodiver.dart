import 'package:auth_app/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatProvider {
  final FirebaseFirestore firebaseFirestore;

  ChatProvider({required this.firebaseFirestore});

  Stream<QuerySnapshot<Map<String, dynamic>>> getChatMessages(String chatId) {
    return firebaseFirestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  void sendMessage({required String chatId, required String message, required String author}) {
    final chatMessage = MessageModel(
      author: author,
      timestamp: DateTime.now(),
      message: message,
    );

    firebaseFirestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(chatMessage.toJson());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserChats(String userId) {
    return firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('contacts')
        .snapshots();
  }

  Future<void> addContact(String userId, String contactId, String contactName) async {
    await firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('contacts')
        .doc(contactId)
        .set({'name': contactName, 'chatId': '$userId-$contactId'});

    await firebaseFirestore
        .collection('users')
        .doc(contactId)
        .collection('contacts')
        .doc(userId)
        .set({'name': userId, 'chatId': '$userId-$contactId'});
  }
  
  Future<void> editContact({
    required String userId,
    required String contactId,
    required String newContactName,
  }) async {
    // Atualiza o nome do contato no Firestore para o usuário atual
    await firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('contacts')
        .doc(contactId)
        .update({'name': newContactName});
  }

  Future<void> deleteContact({
    required String userId,
    required String contactId,
  }) async {
    // Remove o contato do Firestore para o usuário atual
    await firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('contacts')
        .doc(contactId)
        .delete();
  }
}