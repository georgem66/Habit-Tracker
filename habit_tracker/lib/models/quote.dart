class Quote {
  final String text;
  final String? author;

  Quote({required this.text, this.author});

  factory Quote.fromMap(Map<String, dynamic> data) {
    return Quote(
      text: data['text'],
      author: data['author'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'author': author,
    };
  }

  @override
  String toString() {
    if (author != null && author!.isNotEmpty) {
      return '"$text" - $author';
    }
    return '"$text"';
  }
}