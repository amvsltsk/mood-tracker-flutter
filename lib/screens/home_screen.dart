import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../core/widgets/custom_text.dart';
import '../core/widgets/app_bottom_navigation.dart';
import 'note_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              const CustomText(
                text: "How are you feeling today?",
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 42),
              _buildCalendar(),
              _buildDailyTipCard(),
              const SizedBox(height: 74),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFF1F59E),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NoteFormScreen(selectedDate: _selectedDay ?? DateTime.now()),
            ),
          ).then((result) {
            if (result == true && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Note saved successfully ✅'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );
            }
          });
        },
        child: const Icon(Icons.add, color: Colors.black),
      ),
      bottomNavigationBar: AppBottomNavigation(currentIndex: 0),
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2040, 12, 31),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      enabledDayPredicate: (day) {
        final checkDate = DateTime(day.year, day.month, day.day);
        return !checkDate.isAfter(DateTime.now());
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: const Color(0xFFF7FAFC),
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFFF1C40F),
            width: 1,
          ),
        ),
        selectedDecoration: BoxDecoration(
          color: const Color(0x80FEFFB6),
          shape: BoxShape.circle,
          border: Border.all(
            color: _selectedDay != null &&
                isSameDay(_selectedDay, DateTime.now())
                ? const Color(0xFFF1C40F)
                : Colors.transparent,
            width: 2,
          ),
        ),
        todayTextStyle: const TextStyle(color: Colors.black),
        selectedTextStyle: const TextStyle(color: Colors.black),
      ),
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      calendarFormat: CalendarFormat.month,
    );
  }

  Widget _buildDailyTipCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFCFDBE8),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SizedBox(height: 30),
          CustomText(
            text: "Daily Tip For a Good Mood 😊",
            fontSize: 16,
            color: Colors.black,
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 8),
          CustomText(
            text: "Take a short walk outside to enjoy fresh air and sunshine",
            fontSize: 21,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 30),
        ],
      ),
    );

  }
  }

