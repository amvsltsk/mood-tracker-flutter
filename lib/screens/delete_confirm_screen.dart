import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/mood_entry.dart';
import '../providers/notes_provider.dart';
import '../core/widgets/custom_text.dart';
import 'package:intl/intl.dart';

class DeleteConfirmationScreen extends StatefulWidget {
  final MoodEntry moodEntry;

  const DeleteConfirmationScreen({super.key, required this.moodEntry});

  @override
  _DeleteConfirmationScreenState createState() =>
      _DeleteConfirmationScreenState();
}

class _DeleteConfirmationScreenState extends State<DeleteConfirmationScreen> {
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    final moodEntry = widget.moodEntry;

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7FAFC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context, false), // false → не видалено
        ),
        title: const CustomText(
          text: "Delete Entry",
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 120),
            const CustomText(
              text: "Entry to Delete",
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8EDF2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                      child: Text(
                        moodEntry.mood,
                        style: const TextStyle(fontSize: 20),
                      )),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "Mood: ${moodEntry.mood}",
                      fontSize: 16,
                    ),
                    CustomText(
                      text: _formattedDate(moodEntry.timestamp),
                      fontSize: 14,
                      color: const Color(0xFF4D7399),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            const CustomText(
              text:
              "Are you sure you want to delete this mood entry? This action cannot be undone.",
              fontSize: 14,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: TextButton(
                      onPressed:
                      _isDeleting ? null : () => Navigator.pop(context, false),
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFE8EDF2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const CustomText(
                        text: "Cancel",
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: TextButton(
                      onPressed: _isDeleting ? null : _deleteMood,
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFF1F59E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isDeleting
                          ? const CircularProgressIndicator(color: Colors.black)
                          : const CustomText(
                        text: "Delete",
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
    );
  }

  Future<void> _deleteMood() async {
    setState(() => _isDeleting = true);
    final provider = context.read<MoodProvider>();

    try {
      await provider.deleteMood(widget.moodEntry.id);

      if (!mounted) return;

      // Повернення результату назад на HistoryPage
      Navigator.pop(context, true); // видалено
    } catch (_) {
      if (!mounted) return;
      Navigator.pop(context, false); // не видалено
    } finally {
      if (mounted) setState(() => _isDeleting = false);
    }
  }
}

String _formattedDate(DateTime date) {
  return DateFormat('MMMM d, y').format(date);
}
