import 'package:flutter/material.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:habit_tracker/services/habit_service.dart';
import 'package:habit_tracker/widgets/streak_counter.dart';

class HabitCard extends StatefulWidget {
  final Habit habit;
  final VoidCallback onCompleted;
  final VoidCallback onDeleted;

  const HabitCard({
    super.key,
    required this.habit,
    required this.onCompleted,
    required this.onDeleted,
  });

  @override
  State<HabitCard> createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard> {
  final HabitService _habitService = HabitService();
  bool _isCompleting = false;

  Future<void> _completeHabit() async {
    if (_isCompleting || widget.habit.isCompletedToday()) return;

    setState(() {
      _isCompleting = true;
    });

    try {
      await _habitService.completeHabit(widget.habit.id);
      widget.onCompleted();
    } finally {
      if (mounted) {
        setState(() {
          _isCompleting = false;
        });
      }
    }
  }

  Future<void> _deleteHabit() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Habit'),
        content: Text(
          'Are you sure you want to delete "${widget.habit.title}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _habitService.deleteHabit(widget.habit.id);
      widget.onDeleted();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = widget.habit.isCompletedToday();

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: isCompleted ? null : _completeHabit,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Completion indicator
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted
                          ? Colors.green
                          : Colors.grey.withOpacity(0.3),
                      border: Border.all(
                        color: isCompleted ? Colors.green : Colors.grey,
                        width: 2,
                      ),
                    ),
                    child: isCompleted
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  // Title
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.habit.title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                decoration: isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                        ),
                        if (widget.habit.description.isNotEmpty)
                          Text(
                            widget.habit.description,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                      ],
                    ),
                  ),
                  // Delete button
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: _deleteHabit,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Streak counter
              StreakCounter(streak: widget.habit.currentStreak),
            ],
          ),
        ),
      ),
    );
  }
}
