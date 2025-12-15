import 'package:flutter/material.dart';
import 'package:mood_diary_app/repositories/auth_repository.dart';
import 'package:provider/provider.dart';
import '../core/widgets/custom_button.dart';
import '../core/widgets/custom_text.dart';
import '../core/widgets/custom_text_field.dart';
import 'package:mood_diary_app/utils/app_strings.dart';
import '../providers/user_provider.dart';
import '../providers/notes_provider.dart';

class LoginScreen extends StatefulWidget{
  final AuthRepository authRepository;
  const LoginScreen({super.key, required this.authRepository});

  @override
  _LoginScreenState createState()=>_LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen>{
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;

  void _login() async{
    if(!_formKey.currentState!.validate()) return;
    setState(()=>_loading = true);
    try{
      final userCredential = await widget.authRepository.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final uid = userCredential.user?.uid;

      if (uid != null) {
        await context.read<UserProvider>().loadUser(uid);
        context.read<MoodProvider>().watchMoods(uid);
      }

      Navigator.pushReplacementNamed(context, '/home');
    }catch (e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }finally{
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7FAFC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: ()=>Navigator.pop(context),
        ),
        title: const CustomText(
          text: AppStrings.appTitle,
          fontWeight: FontWeight.bold,
          fontSize:18,
          color: Colors.black,
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child:Form(
              key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children:[
                const SizedBox(height: 128),
                CustomText(
                  text: AppStrings.welcomeBack,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 75),
                CustomTextField(
                  controller: _emailController,
                  hintText: AppStrings.emailHint,
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) {
                    if (val == null || val.isEmpty) return AppStrings.emptyField;
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val)) return AppStrings.invalidEmail;
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  controller: _passwordController,
                  hintText: AppStrings.passwordHint,
                  obscureText: true,
                  validator: (val) => val==null || val.isEmpty ? AppStrings.emptyField : null,
                ),
                const SizedBox(height: 24),
                _loading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFFF1F59E)))
                : CustomButton(
                  text: AppStrings.loginTitle,
                  backgroundColor: const Color(0xFFF1F59E),
                  textColor: Colors.black,
                  onPressed: _login,
                ),
                const SizedBox(height: 50),
                Opacity(
                  opacity: 0.25,
                  child: Image.asset(
                    'assets/images/logo.png',
                    width:245,
                    height:245,
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
