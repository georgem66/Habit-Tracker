import 'package:flutter/material.dart';
import 'package:habit_tracker/services/auth_service.dart';
import 'package:provider/provider.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  PremiumScreenState createState() => PremiumScreenState();
}

class PremiumScreenState extends State<PremiumScreen> {
  bool _isLoading = false;

  Future<void> _upgradeToPremium() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // In a real app, you would integrate with In-App Purchase
      // For this example, we'll just update the user's status directly
      final authService = Provider.of<AuthService>(context, listen: false);
      await authService.updatePremiumStatus(true);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Upgraded to Premium successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error upgrading: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Premium Features'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Premium Header
              const Center(
                child: Icon(
                  Icons.workspace_premium,
                  size: 80,
                  color: Colors.amber,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Upgrade to Premium',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Unlock the full potential of your habit tracking journey',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 32),

              // Premium Features
              _buildFeatureItem(
                'Unlimited Habits',
                'Create and track up to 10 habits instead of just 3',
                Icons.check_circle,
              ),
              _buildFeatureItem(
                'Advanced Statistics',
                'Get detailed insights about your progress',
                Icons.bar_chart,
              ),
              _buildFeatureItem(
                'Custom Reminders',
                'Set personalized notifications for each habit',
                Icons.notifications_active,
              ),
              _buildFeatureItem(
                'Dark Theme',
                'Enable night mode for comfortable viewing',
                Icons.dark_mode,
              ),
              _buildFeatureItem(
                'No Ads',
                'Enjoy an ad-free experience',
                Icons.block,
              ),
              _buildFeatureItem(
                'Premium Support',
                'Get priority customer support',
                Icons.support_agent,
              ),
              const SizedBox(height: 32),

              // Price
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Special Offer',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '\$4.99',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        Text(
                          '/month',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Or \$49.99/year (save 20%)',
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Upgrade Button
              ElevatedButton(
                onPressed: _isLoading ? null : _upgradeToPremium,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Upgrade Now',
                        style: TextStyle(fontSize: 18),
                      ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Cancel anytime. 7-day free trial available.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String title, String description, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.green, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
