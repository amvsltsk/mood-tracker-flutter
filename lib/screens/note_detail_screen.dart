import 'package:flutter/material.dart';
import '../models/mood_entry.dart';
import '../core/widgets/custom_text.dart';
import '../core/widgets/app_bottom_navigation.dart';
import 'package:intl/intl.dart';
import 'note_form_screen.dart';
import 'delete_confirm_screen.dart';
import '../providers/notes_provider.dart';
import 'package:provider/provider.dart';

class MoodDetailScreen extends StatelessWidget {
  final MoodEntry moodEntry;

  const MoodDetailScreen({
    super.key,
    required this.moodEntry,
  });

  @override
  Widget build(BuildContext context) {
    final moodProvider = context.read<MoodProvider>();

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
          text: "Mood Entry",
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 224),
              Center(
                child: Text(
                  moodEntry.mood,
                  style: const TextStyle(fontSize: 22),
                ),
              ),
              const SizedBox(height: 16),
              CustomText(
                text: _formattedDate(moodEntry.timestamp),
                fontSize: 14,
                color: const Color(0xFF4D7399),
              ),
              const SizedBox(height: 16),
              CustomText(
                text: moodEntry.comment?.isEmpty ?? true
                    ? "No content"
                    : moodEntry.comment!,
                fontSize: 16,
                color: moodEntry.comment?.isEmpty ?? true
                    ? const Color(0xFF4D7399)
                    : Colors.black,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: TextButton(
                        onPressed: () async {
                          final deleted = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  DeleteConfirmationScreen(moodEntry: moodEntry),
                            ),
                          );
                          if (deleted == true && context.mounted) {
                            moodProvider.deleteMood(moodEntry.id);
                            Navigator.pop(context, 'deleted');
                          }
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFFE8EDF2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const CustomText(
                          text: "Delete",
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: TextButton(
                        onPressed: () async {
                          final updated = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => NoteFormScreen(
                                selectedDate: moodEntry.timestamp,
                                isEditing: true,
                                moodEntry: MoodEntry(
                                  id: moodEntry.id,
                                  userId: moodEntry.userId,
                                  timestamp: moodEntry.timestamp,
                                  mood: moodEntry.mood,
                                  comment: moodEntry.comment,
                                ),
                              ),
                            ),
                          );
                          if (updated == 'saved' && context.mounted) {
                            Navigator.pop(context, 'updated');
                          }
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFFE8EDF2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const CustomText(
                          text: "Edit",
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavigation(currentIndex: 1),
    );
  }

  String _formattedDate(DateTime date) {
    return DateFormat('MMMM d, y').format(date);
  }
}
