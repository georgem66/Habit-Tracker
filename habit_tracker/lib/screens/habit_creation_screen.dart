import 'package:flutter/material.dart';
import 'package:habit_tracker/services/habit_service.dart';

class HabitCreationScreen extends StatefulWidget {
  final int maxHabits;

  const HabitCreationScreen({
    super.key,
    required this.maxHabits,
  });

  @override
  HabitCreationScreenState createState() => HabitCreationScreenState();
}

class HabitCreationScreenState extends State<HabitCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final HabitService _habitService = HabitService();
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    setState(() {
      _errorMessage = message;
      _isLoading = false;
    });
  }

  Future<void> _createHabit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      await _habitService.createHabit(
        _titleController.text.trim(),
        _descriptionController.text.trim(),
      );

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      _showError(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Habit'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Info Banner
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade100),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue.shade700),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'You can create up to ${widget.maxHabits} habits.',
                          style: TextStyle(color: Colors.blue.shade700),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Title Field
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Habit Title',
                    hintText: 'e.g., Meditate 10 mins',
                    prefixIcon: Icon(Icons.title),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title for your habit';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Description Field
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description (Optional)',
                    hintText: 'e.g., Use meditation app for guidance',
                    prefixIcon: Icon(Icons.description),
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),

                // Error Message
                if (_errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                // Create Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _createHabit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Create Habit'),
                ),

                // Habit Ideas Section
                const SizedBox(height: 32),
                const Text(
                  'Need ideas? Try these habits:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                _buildHabitIdea(
                  'Read 20 pages',
                  'Daily reading to expand knowledge',
                  Icons.book,
                ),
                _buildHabitIdea(
                  'Drink 8 glasses of water',
                  'Stay hydrated throughout the day',
                  Icons.water_drop,
                ),
                _buildHabitIdea(
                  'Exercise for 30 minutes',
                  'Stay active and healthy',
                  Icons.fitness_center,
                ),
                _buildHabitIdea(
                  'Journal for 5 minutes',
                  'Reflect on daily experiences',
                  Icons.edit_note,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHabitIdea(String title, String description, IconData icon) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(description),
      onTap: () {
        setState(() {
          _titleController.text = title;
          _descriptionController.text = description;
        });
      },
    );
  }
}
