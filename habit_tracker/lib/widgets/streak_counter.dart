import 'package:flutter/material.dart';

class StreakCounter extends StatelessWidget {
  final int streak;

  const StreakCounter({super.key, required this.streak});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getStreakColor().withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _getStreakColor(), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_fire_department, color: _getStreakColor(), size: 20),
          const SizedBox(width: 6),
          Text(
            '$streak day${streak != 1 ? 's' : ''} streak',
            style: TextStyle(
              color: _getStreakColor(),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStreakColor() {
    if (streak >= 30) return Colors.purple;
    if (streak >= 14) return Colors.orange;
    if (streak >= 7) return Colors.blue;
    if (streak >= 3) return Colors.green;
    return Colors.grey;
  }
}
