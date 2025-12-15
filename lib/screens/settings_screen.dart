import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/widgets/custom_text.dart';
import '../core/widgets/app_bottom_navigation.dart';
import '../providers/user_provider.dart';
import 'profile_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TimeOfDay _reminderTime = const TimeOfDay(hour: 9, minute: 0);

  void _showLanguageDialog(BuildContext context, UserProvider provider, user) {
    final languages = ['English', 'Ukrainian', 'Spanish', 'French'];

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const CustomText(
          text: 'Select Language',
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: languages.map((lang) {
            final isSelected = user.language == lang;
            return ListTile(
              title: Text(lang),
              leading: Icon(
                isSelected ? Icons.check_circle : Icons.circle_outlined,
                color: isSelected ? const Color(0xFFF1F59E) : Colors.grey,
              ),
              onTap: () async {
                try {
                  await provider.updateUser(user.copyWith(language: lang));
                  if (dialogContext.mounted) Navigator.pop(dialogContext);
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to update language: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showThemeDialog(BuildContext context, UserProvider provider, user) {
    final themes = ['Light', 'Dark', 'System'];

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const CustomText(
          text: 'Select Theme',
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: themes.map((theme) {
            final isSelected = user.theme == theme;
            return ListTile(
              title: Text(theme),
              leading: Icon(
                isSelected ? Icons.check_circle : Icons.circle_outlined,
                color: isSelected ? const Color(0xFFF1F59E) : Colors.grey,
              ),
              onTap: () async {
                try {
                  await provider.updateUser(user.copyWith(theme: theme));
                  if (dialogContext.mounted) Navigator.pop(dialogContext);
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to update theme: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<void> _showTimePicker(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: const Color(0xFFF7FAFC),                 // фон вікна
              hourMinuteColor: const Color(0xFFF1F59E),      // фон часу
              hourMinuteTextColor: Colors.black,             // текст часу
              dialBackgroundColor: const Color(0xFFE8EDF2),  // фон циферблату
              dialHandColor: Colors.black,        // стрілка
              entryModeIconColor: Colors.black,              // іконка редагування
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,    // OK / CANCEL
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _reminderTime = picked;
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Reminder time set to ${picked.format(context)}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final user = userProvider.user;

    if (userProvider.isLoading || user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7FAFC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const CustomText(
          text: "Settings",
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notifications Section
              const CustomText(
                text: "Notifications",
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),

              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Daily Reminders
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      value: user.reminders,
                      onChanged: (val) async {
                        try {
                          await userProvider.updateUser(user.copyWith(reminders: val));
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to update: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      title: const Align(
                        alignment: Alignment.centerLeft,
                        child: CustomText(
                          text: "Daily Reminders",
                          fontSize: 16,
                        ),
                      ),
                      subtitle: const Text(
                        "Set daily reminders to track your mood",
                        style: TextStyle(fontSize: 14, color: Color(0xFF4D7399)),
                      ),
                      activeTrackColor: const Color(0xFFE8EDF2),
                      activeThumbColor: const Color(0xFFF1F59E),
                    ),

                    // Reminder Time
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Align(
                        alignment: Alignment.centerLeft,
                        child: CustomText(
                          text: "Reminder Time",
                          fontSize: 16,
                        ),
                      ),
                      subtitle: const Text(
                        "Choose the time for your daily mood check-in",
                        style: TextStyle(fontSize: 14, color: Color(0xFF4D7399)),
                      ),
                      trailing: CustomText(
                        text: _reminderTime.format(context),
                        fontSize: 16,
                      ),
                      onTap: () => _showTimePicker(context),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              // Account Section
              const CustomText(
                text: "Account",
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),

              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Align(
                        alignment: Alignment.centerLeft,
                        child: CustomText(text: "Manage Account", fontSize: 16),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ProfileScreen()),
                        );
                      },
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Align(
                        alignment: Alignment.centerLeft,
                        child: CustomText(text: "Privacy Settings", fontSize: 16),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // General Section
              const CustomText(
                text: "General",
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 16),

              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title:
                      const Align(alignment: Alignment.centerLeft, child: CustomText(text: "Language", fontSize: 16)),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => _showLanguageDialog(context, userProvider, user),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Align(alignment: Alignment.centerLeft, child: CustomText(text: "Theme", fontSize: 16)),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => _showThemeDialog(context, userProvider, user),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Align(
                          alignment: Alignment.centerLeft, child: CustomText(text: "Help & Support", fontSize: 16)),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {},
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title:
                      const Align(alignment: Alignment.centerLeft, child: CustomText(text: "About", fontSize: 16)),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavigation(currentIndex: 3),
    );
  }
}
