import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/widgets/custom_text.dart';
import '../core/widgets/custom_text_field.dart';
import '../core/widgets/app_bottom_navigation.dart';
import '../providers/user_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    final user = context.read<UserProvider>().user;

    firstNameController = TextEditingController(text: user?.firstName ?? '');
    lastNameController = TextEditingController(text: user?.lastName ?? '');
    emailController = TextEditingController(text: user?.email ?? '');
    passwordController = TextEditingController(text: '******'); // пароль недоступний
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _saveChanges() async {
    final userProvider = context.read<UserProvider>();
    final user = userProvider.user;

    if (user == null) return;

    if (firstNameController.text.trim().isEmpty) {
      _showErrorSnackbar('Name cannot be empty');
      return;
    }

    if (lastNameController.text.trim().isEmpty) {
      _showErrorSnackbar('Surname cannot be empty');
      return;
    }

    try {
      await userProvider.updateUser(
        user.copyWith(
          firstName: firstNameController.text.trim(),
          lastName: lastNameController.text.trim(),
        ),
      );
      _showSuccessSnackbar('Profile updated successfully');
    } catch (e) {
      _showErrorSnackbar('Failed to update profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final user = userProvider.user;

    if (userProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (user == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CustomText(text: "User not found"),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const CustomText(text: "Go Back"),
              ),
            ],
          ),
        ),
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
          text: "Account",
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              child: const Icon(Icons.person, size: 50),
            ),
            const SizedBox(height: 16),
            CustomText(
              text: "${user.firstName} ${user.lastName}",
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 24),

            // Name
            const Align(
              alignment: Alignment.centerLeft,
              child: CustomText(text: "Name", fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 8),
            CustomTextField(
              hintText: "First Name",
              controller: firstNameController,
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: 24),

            // Surname
            const Align(
              alignment: Alignment.centerLeft,
              child: CustomText(text: "Surname", fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 8),
            CustomTextField(
              hintText: "Last Name",
              controller: lastNameController,
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: 24),

            // Email
            const Align(
              alignment: Alignment.centerLeft,
              child: CustomText(text: "Email", fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 8),
            Opacity(
              opacity: 0.6,
              child: IgnorePointer(
                child: CustomTextField(
                  hintText: "Email",
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Password
            const Align(
              alignment: Alignment.centerLeft,
              child: CustomText(text: "Password", fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 8),
            Opacity(
              opacity: 0.6,
              child: IgnorePointer(
                child: CustomTextField(
                  hintText: "Password",
                  controller: passwordController,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Save Changes button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 140,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF1F59E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const CustomText(
                      text: "Save Changes",
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavigation(currentIndex: 3),
    );
  }
}
