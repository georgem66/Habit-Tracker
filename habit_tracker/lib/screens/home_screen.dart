import 'package:flutter/material.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:habit_tracker/models/quote.dart';
import 'package:habit_tracker/models/user.dart';
import 'package:habit_tracker/screens/habit_creation_screen.dart';
import 'package:habit_tracker/screens/premium_screen.dart';
import 'package:habit_tracker/screens/profile_screen.dart';
import 'package:habit_tracker/services/auth_service.dart';
import 'package:habit_tracker/services/habit_service.dart';
import 'package:habit_tracker/services/quote_service.dart';
import 'package:habit_tracker/exceptions/network_exception.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final HabitService _habitService = HabitService();
  final QuoteService _quoteService = QuoteService();
  UserModel? _userData;
  bool _isLoading = true;
  late AuthService _authService;

  @override
  void initState() {
    super.initState();
    _quoteService.loadQuotes();
    // Moved to didChangeDependencies to ensure context is available
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authService = Provider.of<AuthService>(context, listen: false);

    // Load user data only once after dependencies are initialized
    if (_isLoading) {
      _loadUserData();
    }
  }

  Future<void> _loadUserData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final userData = await _authService.getCurrentUserData();

      if (mounted) {
        setState(() {
          _userData = userData;
          _isLoading = false;
        });
      }
    } on NetworkException catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Network error: ${e.message}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading user data: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _navigateToAddHabit() async {
    if (_userData == null) return;

    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => HabitCreationScreen(maxHabits: _userData!.maxHabits),
      ),
    );

    // Refresh user data if a habit was created (result is true)
    if (result == true) {
      _loadUserData();
    }
  }

  void _showQuotePopup() {
    try {
      Quote quote = _quoteService.getRandomQuote();

      if (mounted) {
        showDialog(
          context: context,
          builder: (ctx) => QuotePopup(quote: quote),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error showing quote: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _onHabitCompleted() {
    _showQuotePopup();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Habits'),
        actions: [
          if (_userData != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    children: [
                      const WidgetSpan(
                        child: Icon(Icons.stars, color: Colors.amber, size: 18),
                        alignment: PlaceholderAlignment.middle,
                      ),
                      TextSpan(
                        text: ' ${_userData!.points}',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () async {
              final result = await Navigator.of(context).push<bool>(
                MaterialPageRoute(
                  builder: (_) => const ProfileScreen(),
                ),
              );

              // Refresh user data if profile was updated
              if (result == true) {
                _loadUserData();
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (_userData != null && !_userData!.isPremium)
                  PremiumBanner(
                    onTap: () async {
                      final result = await Navigator.of(context).push<bool>(
                        MaterialPageRoute(
                          builder: (_) => const PremiumScreen(),
                        ),
                      );

                      // Refresh user data if premium status changed
                      if (result == true) {
                        _loadUserData();
                      }
                    },
                  ),
                Expanded(
                  child: StreamBuilder<List<Habit>>(
                    stream: _habitService.getHabits(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting &&
                          snapshot.data == null) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                size: 48,
                                color: Colors.red,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Error loading habits',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                snapshot.error.toString(),
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {}); // Force rebuild
                                },
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      }

                      final habits = snapshot.data ?? [];

                      if (habits.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.check_box_outline_blank,
                                size: 80,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'No habits yet',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Tap the + button to add a new habit',
                                style: TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton.icon(
                                onPressed: _navigateToAddHabit,
                                icon: const Icon(Icons.add),
                                label: const Text('Add Your First Habit'),
                              ),
                            ],
                          ),
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: () async {
                          await _loadUserData();
                          setState(() {}); // Force rebuild to refresh stream
                        },
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: habits.length,
                          itemBuilder: (context, index) {
                            return HabitCard(
                              habit: habits[index],
                              onCompleted: _onHabitCompleted,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddHabit,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class HabitCard extends StatelessWidget {
  final Habit habit;
  final VoidCallback onCompleted;

  const HabitCard({
    Key? key,
    required this.habit,
    required this.onCompleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HabitService habitService = HabitService();
    final bool isCompleted = habit.isCompletedToday();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .primaryColor
                        .withAlpha((255 * 0.1).toInt()),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    isCompleted
                        ? Icons.check_circle
                        : Icons.check_circle_outline,
                    color: isCompleted
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).primaryColor,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        habit.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      if (habit.description.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            habit.description,
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodySmall?.color,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.local_fire_department,
                            color: habit.currentStreak > 0
                                ? Theme.of(context).colorScheme.secondary
                                : Colors.grey,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Streak: ${habit.currentStreak} ${habit.currentStreak == 1 ? 'day' : 'days'}',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color:
                                  habit.currentStreak > 0 ? null : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isCompleted
                    ? null
                    : () async {
                        final scaffoldMessenger = ScaffoldMessenger.of(context);
                        // Show loading indicator
                        scaffoldMessenger.showSnackBar(
                          const SnackBar(
                            content: Text('Updating habit...'),
                            duration: Duration(seconds: 2),
                          ),
                        );

                        try {
                          // Complete the habit
                          await habitService.completeHabit(habit);

                          // Hide the loading snackbar
                          scaffoldMessenger.hideCurrentSnackBar();

                          // Only trigger completion callback if still mounted
                          if (context.mounted) {
                            onCompleted();
                          }
                        } catch (e) {
                          // Hide the loading snackbar before showing error
                          scaffoldMessenger.hideCurrentSnackBar();

                          // Show error only if still mounted
                          if (context.mounted) {
                            scaffoldMessenger.showSnackBar(
                              SnackBar(
                                content: Text('Error: ${e.toString()}'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isCompleted
                      ? Colors.grey[300]
                      : Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  isCompleted ? 'Completed Today' : 'Mark as Complete',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuotePopup extends StatelessWidget {
  final Quote quote;

  const QuotePopup({
    Key? key,
    required this.quote,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.format_quote,
              size: 40,
              color: Colors.blueGrey,
            ),
            const SizedBox(height: 16),
            Text(
              quote.text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 8),
            if (quote.author != null && quote.author!.isNotEmpty)
              Text(
                '— ${quote.author}',
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

class PremiumBanner extends StatelessWidget {
  final VoidCallback onTap;

  const PremiumBanner({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        color: Colors.amber.shade100,
        child: Row(
          children: [
            const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Upgrade to Premium for unlimited habits!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }
}
