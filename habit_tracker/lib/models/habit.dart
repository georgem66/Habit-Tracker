import 'package:cloud_firestore/cloud_firestore.dart';

class Habit {
  final String id;
  final String title;
  final String description;
  final List<DateTime> completedDates;
  final DateTime createdAt;
  int currentStreak;

  Habit({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    this.completedDates = const [],
    this.currentStreak = 0,
  });

  factory Habit.fromMap(Map<String, dynamic> data) {
    List<DateTime> completed = [];
    if (data['completedDates'] != null) {
      for (var date in data['completedDates']) {
        completed.add((date as Timestamp).toDate());
      }
    }

    return Habit(
      id: data['id'],
      title: data['title'],
      description: data['description'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      completedDates: completed,
      currentStreak: data['currentStreak'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt,
      'completedDates': completedDates,
      'currentStreak': currentStreak,
    };
  }

  bool isCompletedToday() {
    if (completedDates.isEmpty) return false;
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    for (var date in completedDates) {
      final completedDate = DateTime(date.year, date.month, date.day);
      if (completedDate.isAtSameMomentAs(today)) {
        return true;
      }
    }
    
    return false;
  }

  // Calculate streak based on consecutive days
  void calculateStreak() {
    if (completedDates.isEmpty) {
      currentStreak = 0;
      return;
    }

    // Sort dates to ensure they are in chronological order
    final sortedDates = [...completedDates]..sort();
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    // Check if completed today or yesterday to maintain streak
    bool completedRecently = false;
    for (var date in sortedDates) {
      final completedDate = DateTime(date.year, date.month, date.day);
      if (completedDate.isAtSameMomentAs(today) || 
          completedDate.isAtSameMomentAs(yesterday)) {
        completedRecently = true;
        break;
      }
    }

    if (!completedRecently) {
      currentStreak = 0;
      return;
    }

    // Calculate consecutive days
    int streak = 1;
    DateTime checkDate = today;
    
    // Start from today and go backwards
    while (true) {
      checkDate = checkDate.subtract(const Duration(days: 1));
      bool foundDate = false;
      
      for (var date in sortedDates) {
        final completedDate = DateTime(date.year, date.month, date.day);
        if (completedDate.isAtSameMomentAs(checkDate)) {
          streak++;
          foundDate = true;
          break;
        }
      }
      
      if (!foundDate) {
        break;
      }
    }
    
    currentStreak = streak;
  }
}