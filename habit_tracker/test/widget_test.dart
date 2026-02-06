// This is a basic Flutter widget test for the Habit Tracker app.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:habit_tracker/models/user.dart';
import 'package:habit_tracker/models/quote.dart';

void main() {
  group('Model Tests', () {
    test('UserModel should be created correctly', () {
      final user = UserModel(
        id: 'test123',
        email: 'test@example.com',
        displayName: 'Test User',
        points: 100,
        isPremium: false,
        maxHabits: 3,
      );

      expect(user.id, 'test123');
      expect(user.email, 'test@example.com');
      expect(user.displayName, 'Test User');
      expect(user.points, 100);
      expect(user.isPremium, false);
      expect(user.maxHabits, 3);
    });

    test('UserModel toMap and fromMap should work correctly', () {
      final user = UserModel(
        id: 'test123',
        email: 'test@example.com',
        displayName: 'Test User',
        points: 50,
      );

      final map = user.toMap();
      final userFromMap = UserModel.fromMap(map);

      expect(userFromMap.id, user.id);
      expect(userFromMap.email, user.email);
      expect(userFromMap.displayName, user.displayName);
      expect(userFromMap.points, user.points);
    });

    test('Habit should be created correctly', () {
      final habit = Habit(
        id: 'habit123',
        title: 'Morning Exercise',
        description: 'Exercise for 30 minutes',
        createdAt: DateTime.now(),
        completedDates: [],
        currentStreak: 0,
      );

      expect(habit.id, 'habit123');
      expect(habit.title, 'Morning Exercise');
      expect(habit.description, 'Exercise for 30 minutes');
      expect(habit.currentStreak, 0);
    });

    test('Habit isCompletedToday should return false for new habit', () {
      final habit = Habit(
        id: 'habit123',
        title: 'Morning Exercise',
        description: 'Exercise for 30 minutes',
        createdAt: DateTime.now(),
      );

      expect(habit.isCompletedToday(), false);
    });

    test('Habit isCompletedToday should return true when completed today', () {
      final habit = Habit(
        id: 'habit123',
        title: 'Morning Exercise',
        description: 'Exercise for 30 minutes',
        createdAt: DateTime.now(),
        completedDates: [DateTime.now()],
      );

      expect(habit.isCompletedToday(), true);
    });

    test('Habit streak calculation should work correctly', () {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));
      final twoDaysAgo = today.subtract(const Duration(days: 2));

      final habit = Habit(
        id: 'habit123',
        title: 'Morning Exercise',
        description: 'Exercise for 30 minutes',
        createdAt: DateTime.now(),
        completedDates: [today, yesterday, twoDaysAgo],
      );

      habit.calculateStreak();
      expect(habit.currentStreak, greaterThanOrEqualTo(1));
    });

    test('Quote should be created correctly', () {
      final quote = Quote(
        text: 'The secret of getting ahead is getting started.',
        author: 'Mark Twain',
      );

      expect(quote.text, 'The secret of getting ahead is getting started.');
      expect(quote.author, 'Mark Twain');
    });

    test('Quote fromJson should work correctly', () {
      final json = {
        'text': 'Success is not final, failure is not fatal.',
        'author': 'Winston Churchill',
      };

      final quote = Quote.fromJson(json);

      expect(quote.text, 'Success is not final, failure is not fatal.');
      expect(quote.author, 'Winston Churchill');
    });
  });

  group('UserModel copyWith Tests', () {
    test('copyWith should update only specified fields', () {
      final user = UserModel(
        id: 'test123',
        email: 'test@example.com',
        displayName: 'Test User',
        points: 100,
      );

      final updatedUser = user.copyWith(points: 200);

      expect(updatedUser.id, user.id);
      expect(updatedUser.email, user.email);
      expect(updatedUser.displayName, user.displayName);
      expect(updatedUser.points, 200);
    });

    test('copyWith should update premium status', () {
      final user = UserModel(
        id: 'test123',
        email: 'test@example.com',
        displayName: 'Test User',
      );

      final premiumUser = user.copyWith(isPremium: true, maxHabits: 10);

      expect(premiumUser.isPremium, true);
      expect(premiumUser.maxHabits, 10);
    });
  });
}
