import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/notes_provider.dart';
import '../models/mood_entry.dart';
import '../core/widgets/app_bottom_navigation.dart';
import '../core/widgets/custom_text.dart';
import 'package:intl/intl.dart';
import '../providers/user_provider.dart';
import 'note_detail_screen.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  DateTimeRange? selectedDateRange;
  String? selectedMood;

  @override
  Widget build(BuildContext context) {
    final moodProvider = context.watch<MoodProvider>();

    List<MoodEntry> moods = moodProvider.filterMoods(
      dateRange: selectedDateRange,
      mood: selectedMood,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      appBar: AppBar(
        title: const CustomText(
          text: "Mood History",
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: const Color(0xFFF7FAFC),
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
              const SizedBox(height: 16),
              const CustomText(
                text: "Filter by Date",
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 12),

              // Date Range Picker
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFCFDBE8), width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Align(
                    alignment: Alignment.centerLeft,
                    child: CustomText(
                      text: selectedDateRange == null
                          ? "Select Date Range"
                          : "${selectedDateRange!.start.day}.${selectedDateRange!.start.month}.${selectedDateRange!.start.year}"
                          " - "
                          "${selectedDateRange!.end.day}.${selectedDateRange!.end.month}.${selectedDateRange!.end.year}",
                      fontSize: 16,
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_drop_down, color: Color(0xFF4D7399), size: 40),
                  onTap: () async {
                    if (selectedDateRange != null) {
                      setState(() {
                        selectedDateRange = null;
                      });
                      return;
                    }

                    DateTimeRange? picked = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            canvasColor: const Color(0xFFF7FAFC),
                            colorScheme: const ColorScheme.light(
                              primary: Color(0xFFF1C40F),
                              onPrimary: Colors.black,
                              surface: Color(0xFFF7FAFC),
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );

                    if (picked != null) {
                      setState(() {
                        selectedDateRange = picked;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 24),

              const CustomText(
                text: "Filter by Mood",
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 12),

              // Mood filter
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: ['😀','🙂','😐','😢','😎'].map((mood) {
                    final isSelected = selectedMood == mood;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedMood = isSelected ? null : mood;
                        });
                      },
                      child: Container(
                        width: 49,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: isSelected
                              ? Border.all(color: const Color(0xFFF9FC2D), width: 1)
                              : Border.all(color: Colors.transparent),
                          color: isSelected ? const Color(0xFFFEFFB6) : const Color(0xFFE8EDF2),
                        ),
                        child: Center(child: Text(mood, style: const TextStyle(fontSize: 14))),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),

              // Mood Entries List
              Expanded(
                child: moodProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : (moodProvider.error != null
                        ? Center(child: Text('Error: ${moodProvider.error}'))
                        : (moods.isEmpty
                            ? const Center(child: Text("No mood entries found"))
                            : ListView.builder(
                                itemCount: moods.length,
                                itemBuilder: (context, index) {
                                  MoodEntry mood = moods[index];
                                  return ListTile(
                                    contentPadding: const EdgeInsets.only(left: 0, right: 16),
                                    leading: Container(
                                      height: 48,
                                      width: 48,
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: const Color(0xFFE8EDF2),
                                      ),
                                      child: Center(child: Text(mood.mood, style: const TextStyle(fontSize: 24))),
                                    ),
                                    title: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          text: _formattedDate(mood.timestamp),
                                          fontSize: 16,
                                        ),
                                        if (mood.comment != null && mood.comment!.isNotEmpty)
                                          CustomText(
                                            text: mood.comment!,
                                            fontSize: 14,
                                            color: const Color(0xFF4D7399),
                                          ),
                                      ],
                                    ),
                                    onTap: () async {
                                      // Перехід на екран деталей
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => MoodDetailScreen(moodEntry: mood),
                                        ),
                                      );

                                    }
                                  );
                                },
                              )
                        )
                    ),
               ),
             ],
           ),
         ),
       ),
       bottomNavigationBar: const AppBottomNavigation(currentIndex: 1),
     );
   }
 }

 String _formattedDate(DateTime date) {
   return DateFormat('MMMM d, y').format(date); // October 26, 2024
 }
