import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/mood_entry.dart';
import '../providers/notes_provider.dart';
import '../core/widgets/custom_text.dart';

class NoteFormScreen extends StatefulWidget {
  final DateTime selectedDate;
  final bool isEditing;
  final MoodEntry? moodEntry;

  const NoteFormScreen({
    super.key,
    required this.selectedDate,
    this.isEditing = false,
    this.moodEntry,
  });

  @override
  _NoteFormScreenState createState() => _NoteFormScreenState();
}

class _NoteFormScreenState extends State<NoteFormScreen> {
  String? selectedMood;
  late TextEditingController _commentController;

  @override
  void initState() {
    super.initState();

    if (widget.isEditing && widget.moodEntry != null) {
      selectedMood = widget.moodEntry!.mood;
      _commentController = TextEditingController(text: widget.moodEntry!.comment);
    } else {
      _commentController = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    final moods = ['😀', '🙂', '😐', '😢', '😎'];

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    CustomText(
                      text: _formattedDate(widget.selectedDate),
                      fontSize: 14,
                      color: const Color(0xFF4D7399),
                    ),
                    const SizedBox(height: 12),
                    if (!widget.isEditing)
                      const CustomText(
                        text: "How are you feeling today?",
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Mood Picker
              SizedBox(
                height: 44,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: moods.map((mood) {
                    final isSelected = selectedMood == mood;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedMood = mood;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? const Color(0xFFF9FC2D) : const Color(0xFFCFDBE8),
                          ),
                          color: isSelected ? const Color(0xFFFEFFB6) : Colors.transparent,
                        ),
                        child: Text(mood, style: const TextStyle(fontSize: 20)),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 36),
              const CustomText(text: "Note", fontSize: 16),
              const SizedBox(height: 12),

              SizedBox(
                height: 144,
                child: TextField(
                  controller: _commentController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    hintText: "Add a note...",
                    filled: true,
                    fillColor: Colors.transparent,
                    hintStyle: const TextStyle(color: Color(0xFF4D7399)),
                    contentPadding: const EdgeInsets.all(12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFCFDBE8)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 148,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const CustomText(text: "Cancel", fontSize: 14),
                    ),
                  ),
                  SizedBox(
                    width: 198,
                    child: ElevatedButton(
                      onPressed: _saveMood,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF1F59E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: CustomText(
                          text: widget.isEditing ? "Save changes" : "Save",
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveMood() async {
    if (selectedMood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a mood 😊"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final moodProvider = Provider.of<MoodProvider>(context, listen: false);

    try {
      if (widget.isEditing && widget.moodEntry != null) {
        final updatedMood = widget.moodEntry!.copyWith(
          mood: selectedMood,
          comment: _commentController.text,
          timestamp: widget.selectedDate,
        );
        await moodProvider.updateMood(updatedMood);
      } else {
        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("User not logged in"),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
        final newMood = MoodEntry(
          id: '',
          userId: currentUser.uid,
          timestamp: widget.selectedDate,
          mood: selectedMood!,
          comment: _commentController.text,
        );
        await moodProvider.addMood(newMood);
      }

      if (mounted) Navigator.pop(context, 'saved');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  String _formattedDate(DateTime date) {
    return DateFormat('MMMM d, y').format(date);
  }
}
