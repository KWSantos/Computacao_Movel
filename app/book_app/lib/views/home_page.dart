import 'package:book_app/helpers/book_helper.dart';
import 'package:book_app/models/book_model.dart';
import 'package:book_app/views/edit_book_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Book> books = [];
  final dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  void _loadBooks() async {
    final loadedBooks = await dbHelper.getBooks();
    setState(() {
      books = loadedBooks;
    });
  }

  void _deleteBook(int id) async {
    bool? confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar Exclusão'),
        content: Text('Você tem certeza que deseja excluir este livro?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmDelete == true) {
      await dbHelper.deleteBook(id);
      _loadBooks();
    }
  }

  void _navigateToEditPage(Book? book) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditBookPage(book: book)),
    );
    if (result != null) {
      _loadBooks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Biblioteca de Livros'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _navigateToEditPage(null),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return ListTile(
            title: Text(book.title),
            subtitle: Text('${book.author} - ${book.year}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _navigateToEditPage(book),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteBook(book.id!),
                ),
              ],
            ),
            onTap: () => _navigateToEditPage(book),
          );
        },
      ),
    );
  }
}