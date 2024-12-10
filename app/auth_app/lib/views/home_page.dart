import 'package:auth_app/providers/chat_prodiver.dart';
import 'package:auth_app/views/chat_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;
  final ChatProvider chatProvider = ChatProvider(firebaseFirestore: FirebaseFirestore.instance);

  void signUserOut() async {
    await FirebaseAuth.instance.signOut();
  }

  void _addContact(BuildContext context) {
    final contactIdController = TextEditingController();
    final contactNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Adicionar Contato'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: contactIdController,
              decoration: const InputDecoration(labelText: 'ID do Contato'),
            ),
            TextField(
              controller: contactNameController,
              decoration: const InputDecoration(labelText: 'Nome do Contato'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final contactId = contactIdController.text.trim();
              final contactName = contactNameController.text.trim();
              if (contactId.isNotEmpty && contactName.isNotEmpty) {
                await chatProvider.addContact(user.uid, contactId, contactName);
                Navigator.pop(context);
              }
            },
            child: const Text('Adicionar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
        actions: [
          IconButton(
            onPressed: () => _addContact(context),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: chatProvider.getUserChats(user.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final contacts = snapshot.data!.docs;

            if (contacts.isEmpty) {
              return const Center(child: Text('Nenhum contato adicionado.'));
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                final contactName = contact['name'] as String;
                final chatId = contact['chatId'] as String;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                          chatId: 'chatId_$index', // ID único do chat
                          chatName: 'Contato $index',
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 2,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue[200],
                        child: Text(
                          contactName[0].toUpperCase(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(contactName),
                      subtitle: const Text('Toque para iniciar a conversa'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Erro ao carregar contatos.'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}