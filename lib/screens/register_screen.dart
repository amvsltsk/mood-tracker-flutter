import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mood_diary_app/utils/app_strings.dart';
import '../core/widgets/custom_button.dart';
import '../core/widgets/custom_text.dart';
import '../core/widgets/custom_text_field.dart';
import '../repositories/auth_repository.dart';
import '../providers/user_provider.dart';
import '../models/user_profile.dart';
import '../providers/notes_provider.dart';

class RegisterScreen extends StatefulWidget {
  final AuthRepository authRepository;

  const RegisterScreen({super.key, required this.authRepository});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      // 1. ✅ Реєструємо користувача в Firebase Auth
      final userCredential = await widget.authRepository.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // 2. ✅ Отримуємо UID нового користувача
      final userId = userCredential.user?.uid;

      if (userId == null) {
        throw Exception('Failed to get user ID');
      }

      // 3. ✅ Створюємо профіль користувача в Firestore через UserProvider
      final userProvider = context.read<UserProvider>();

      final newUser = UserProfile(
        id: userId,
        firstName: _nameController.text.trim(),
        lastName: _surnameController.text.trim(),
        email: _emailController.text.trim(),
        language: 'English', // За замовчуванням
        theme: 'Light', // За замовчуванням
        reminders: true, // За замовчуванням
      );

      // 4. ✅ Використовуємо createUser() з UserRepository
      await userProvider.createUser(newUser);

      // 5. Load the newly created user into provider and start moods stream
      await userProvider.loadUser(userId);
      context.read<MoodProvider>().watchMoods(userId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.registrationSuccess)),
        );
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7FAFC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const CustomText(
          text: AppStrings.appTitle,
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.black,
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 100),
                  CustomTextField(
                    controller: _nameController,
                    hintText: AppStrings.nameHint,
                    validator: (val) => val == null || val.isEmpty
                        ? AppStrings.emptyField
                        : null,
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    controller: _surnameController,
                    hintText: AppStrings.surnameHint,
                    validator: (val) => val == null || val.isEmpty
                        ? AppStrings.emptyField
                        : null,
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    controller: _emailController,
                    hintText: AppStrings.emailHint,
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) {
                      if (val == null || val.isEmpty) return AppStrings.emptyField;
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val)) {
                        return AppStrings.invalidEmail;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    controller: _passwordController,
                    hintText: AppStrings.passwordHint,
                    obscureText: true,
                    validator: (val) {
                      if (val == null || val.isEmpty) return AppStrings.emptyField;
                      if (val.length < 6) return AppStrings.passwordLength;
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    controller: _confirmController,
                    hintText: AppStrings.confirmPasswordHint,
                    obscureText: true,
                    validator: (val) {
                      if (val == null || val.isEmpty) return AppStrings.emptyField;
                      if (val != _passwordController.text) {
                        return AppStrings.passwordsDoNotMatch;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  _loading
                      ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFF1F59E),
                    ),
                  )
                      : CustomButton(
                    text: AppStrings.signUpTitle,
                    backgroundColor: const Color(0xFFF1F59E),
                    textColor: Colors.black,
                    onPressed: _signUp,
                  ),
                  Opacity(
                    opacity: 0.25,
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 245,
                      height: 245,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}