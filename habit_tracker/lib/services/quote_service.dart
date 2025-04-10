import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:habit_tracker/models/quote.dart';

class QuoteService {
  List<Quote> _quotes = [];
  final Random _random = Random();

  // Load quotes from JSON file
  Future<void> loadQuotes() async {
    try {
      final String data = await rootBundle.loadString('assets/quotes.json');
      final List<dynamic> jsonData = json.decode(data);
      
      _quotes = jsonData.map((json) => Quote.fromMap(json)).toList();
    } catch (e) {
      // If error loading quotes, use default quotes
      _quotes = [
        Quote(text: 'Small steps beat big dreams.'),
        Quote(text: 'Consistency is the key to success.', author: 'Anonymous'),
        Quote(text: 'Every habit is a brick in building your future.'),
        Quote(text: "Today's efforts are tomorrow's results."),
        Quote(text: 'Progress is better than perfection.'),
      ];
    }
  }

  // Get a random quote
  Quote getRandomQuote() {
    if (_quotes.isEmpty) {
      return Quote(text: 'Small steps beat big dreams.');
    }
    
    int index = _random.nextInt(_quotes.length);
    return _quotes[index];
  }
}