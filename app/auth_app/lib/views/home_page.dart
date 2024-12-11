import 'package:auth_app/providers/chat_prodiver.dart';
import 'package:auth_app/views/chat_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;
  final ChatProvider chatProvider = ChatProvider(firebaseFirestore: FirebaseFirestore.instance);

  void signUserOut(BuildContext context) async {
    final confirm = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sair'),
          content: const Text('Você tem certeza que deseja sair?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Sair'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, '/login'); // Ajuste para sua rota de login
    }
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

  void _editContactDialog(
      BuildContext context, String contactId, String currentName) {
    final nameController = TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Contato'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Novo Nome'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                final newName = nameController.text.trim();
                if (newName.isNotEmpty) {
                  await chatProvider.editContact(
                    userId: user.uid,
                    contactId: contactId,
                    newContactName: newName,
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteContact(BuildContext context, String contactId) async {
    final confirm = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir Contato'),
          content: const Text('Tem certeza que deseja excluir este contato?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await chatProvider.deleteContact(userId: user.uid, contactId: contactId);
    }
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
          IconButton(
            onPressed: () => signUserOut(context),
            icon: const Icon(Icons.logout),
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
                final contactId = contact.id;
                final contactName = contact['name'] as String;
                final chatId = contact['chatId'] as String;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                          chatId: chatId,
                          chatName: contactName,
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
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') {
                            _editContactDialog(context, contactId, contactName);
                          } else if (value == 'delete') {
                            _deleteContact(context, contactId);
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Text('Editar'),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('Excluir'),
                          ),
                        ],
                      ),
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
