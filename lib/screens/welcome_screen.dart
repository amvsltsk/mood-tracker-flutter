import 'package:flutter/material.dart';
import '../core/widgets/custom_button.dart';
import '../core/widgets/custom_text.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'home_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width:216,
                height:215,
              ),
              const SizedBox(height: 20),
              const CustomText(
                text: 'Track your mood,\nunderstand yourself',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 12),
              const CustomText(
                text:
                "Gain insights into your emotional well-being\nwith our easy-to-use mood tracker.",
                fontSize:16,
                color: Colors.black,
              ),
              const SizedBox(height:12),
              CustomButton(
                text: 'Sign Up',
                backgroundColor: const Color(0xFFF1F59E),
                textColor: Colors.black,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/register'
                  );
                },
              ),
              const SizedBox(height: 12),
              CustomButton(
                text: 'Login',
                backgroundColor: const Color(0xFFE8EDF2),
                textColor: Colors.black,
                onPressed: () {
                  Navigator.pushNamed(
                      context,
                      '/login'
                  );
                },
              ),
              const SizedBox(height: 225),
              CustomText(
                text: 'By continuing, you agree to our Terms of Service and\nPrivacy Policy.',
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: const Color(0xFF4D7399),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
