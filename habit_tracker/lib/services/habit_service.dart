import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:habit_tracker/models/habit.dart';

class HabitService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get all habits for the current user
  Stream<List<Habit>> getHabits() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      return Stream.value([]);
    }

    return _db
        .collection('users')
        .doc(userId)
        .collection('habits')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        data['id'] = doc.id;
        return Habit.fromMap(data);
      }).toList();
    });
  }

  // Create a new habit
  Future<Habit?> createHabit(String title, String description) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return null;

      // Check the number of existing habits
      QuerySnapshot existingHabits = await _db
          .collection('users')
          .doc(userId)
          .collection('habits')
          .get();

      // Check if user is premium from the users collection
      DocumentSnapshot userDoc = await _db.collection('users').doc(userId).get();
      bool isPremium = (userDoc.data() as Map<String, dynamic>)['isPremium'] ?? false;
      int maxHabits = (userDoc.data() as Map<String, dynamic>)['maxHabits'] ?? 3;

      // Check if user has reached the maximum number of habits
      if (existingHabits.docs.length >= maxHabits) {
        throw Exception(
            isPremium
                ? "You've reached your habit limit. Please complete or remove an existing habit."
                : "Free users can only track up to 3 habits. Upgrade to premium for more!");
      }

      final newHabit = Habit(
        id: '', // Will be set after document creation
        title: title,
        description: description,
        createdAt: DateTime.now(),
      );

      DocumentReference docRef = await _db
          .collection('users')
          .doc(userId)
          .collection('habits')
          .add(newHabit.toMap());

      return Habit(
        id: docRef.id,
        title: title,
        description: description,
        createdAt: newHabit.createdAt,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error creating habit: $e');
      }
      rethrow;
    }
  }

  // Update a habit
  Future<void> updateHabit(Habit habit) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      await _db
          .collection('users')
          .doc(userId)
          .collection('habits')
          .doc(habit.id)
          .update(habit.toMap());
    } catch (e) {
      if (kDebugMode) {
        print('Error updating habit: $e');
      }
    }
  }

  // Delete a habit
  Future<void> deleteHabit(String habitId) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      await _db
          .collection('users')
          .doc(userId)
          .collection('habits')
          .doc(habitId)
          .delete();
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting habit: $e');
      }
    }
  }

  // Mark a habit as completed for today
  Future<void> completeHabit(Habit habit) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      // Check if already completed today
      if (habit.isCompletedToday()) {
        return;
      }

      // Add today's date to completed dates
      final completedDates = List<DateTime>.from(habit.completedDates);
      completedDates.add(DateTime.now());

      // Update streak
      Habit updatedHabit = Habit(
        id: habit.id,
        title: habit.title,
        description: habit.description,
        createdAt: habit.createdAt,
        completedDates: completedDates,
        currentStreak: habit.currentStreak,
      );
      
      updatedHabit.calculateStreak();

      // Update the habit document
      await _db
          .collection('users')
          .doc(userId)
          .collection('habits')
          .doc(habit.id)
          .update({
        'completedDates': FieldValue.arrayUnion([Timestamp.now()]),
        'currentStreak': updatedHabit.currentStreak,
      });

      // Update user points
      await _db.collection('users').doc(userId).update({
        'points': FieldValue.increment(10), // Add 10 points for each completed habit
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error completing habit: $e');
      }
    }
  }
}