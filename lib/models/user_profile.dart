class UserProfile {
  final String id; // Це Firebase Auth UID
  final String firstName;
  final String lastName;
  final String email;

  final String language;
  final String theme;
  final bool reminders;

  UserProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.language,
    required this.theme,
    required this.reminders,
  });

  factory UserProfile.fromMap(String id, Map<String, dynamic> json) {
    return UserProfile(
      id: id,
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      language: json['settings']?['language'] ?? 'English',
      theme: json['settings']?['theme'] ?? 'Light',
      reminders: json['settings']?['reminders'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'settings': {
        'language': language,
        'theme': theme,
        'reminders': reminders,
      }
    };
  }

  UserProfile copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? language,
    String? theme,
    bool? reminders,
  }) {
    return UserProfile(
      id: id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      language: language ?? this.language,
      theme: theme ?? this.theme,
      reminders: reminders ?? this.reminders,
    );
  }
}