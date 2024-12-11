import 'package:book_app/helpers/book_helper.dart';
import 'package:book_app/models/book_model.dart';
import 'package:flutter/material.dart';

class EditBookPage extends StatefulWidget {
  final Book? book;
  EditBookPage({super.key, this.book});

  @override
  State<EditBookPage> createState() => _EditBookPageState();
}

class _EditBookPageState extends State<EditBookPage> {
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _yearController = TextEditingController();
  final dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    if (widget.book != null) {
      _titleController.text = widget.book!.title;
      _authorController.text = widget.book!.author;
      _yearController.text = widget.book!.year.toString();
    }
  }

  void _saveBook() async {
    final title = _titleController.text;
    final author = _authorController.text;
    final year = int.tryParse(_yearController.text) ?? 0;

    if (title.isEmpty || author.isEmpty || year <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, preencha todos os campos.')),
      );
      return;
    }

    final book = Book(
      id: widget.book?.id,
      title: title,
      author: author,
      year: year,
    );

    if (widget.book == null) {
      await dbHelper.insertBook(book);
    } else {
      await dbHelper.updateBook(book);
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book == null ? 'Novo Livro' : 'Editar Livro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: _authorController,
              decoration: InputDecoration(labelText: 'Autor'),
            ),
            TextField(
              controller: _yearController,
              decoration: InputDecoration(labelText: 'Ano'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveBook,
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}