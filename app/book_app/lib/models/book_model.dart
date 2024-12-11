class Book {
  int? id;
  String title;
  String author;
  int year;

  Book({this.id, required this.title, required this.author, required this.year});

  // Converter de/para Map para interagir com o SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'year': year,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      year: map['year'],
    );
  }
}