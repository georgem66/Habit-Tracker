class UserModel {
  final String id;
  final String email;
  final String displayName;
  final int points;
  final bool isPremium;
  final int maxHabits;

  UserModel({
    required this.id,
    required this.email,
    required this.displayName,
    this.points = 0,
    this.isPremium = false,
    this.maxHabits = 3,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      id: data['id'],
      email: data['email'],
      displayName: data['displayName'] ?? 'User',
      points: data['points'] ?? 0,
      isPremium: data['isPremium'] ?? false,
      maxHabits: data['maxHabits'] ?? 3,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'points': points,
      'isPremium': isPremium,
      'maxHabits': maxHabits,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    int? points,
    bool? isPremium,
    int? maxHabits,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      points: points ?? this.points,
      isPremium: isPremium ?? this.isPremium,
      maxHabits: maxHabits ?? this.maxHabits,
    );
  }
}