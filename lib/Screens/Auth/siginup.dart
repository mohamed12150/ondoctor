import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:get/get.dart';
import 'package:ondoctor/Screens/Auth/Login_page.dart';
import 'package:ondoctor/about.dart/Privacy%20Policy.dart';
import 'package:ondoctor/about.dart/Terms%20and%20Conditions.dart';
import '../../services/register_service.dart';
// import '../services/register_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  String _role = 'doctor'; // patient أو doctor


  DateTime? _selectedDate;
  bool _agreeToTerms = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _loading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  bool _isPasswordValid(String password) {
    return password.length >= 8 && RegExp(r'^[A-Z]').hasMatch(password);
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate() && _selectedDate != null && _agreeToTerms) {
      setState(() => _loading = true);
      try {
        final result = await RegisterService.register(
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          phone: phoneController.text.trim(),
          password: passwordController.text.trim(),
          confirmPassword: confirmPasswordController.text.trim(),
          dateOfBirth: _selectedDate!.toIso8601String().split('T')[0],
          role: _role,
        );

        print("🔹 Result: $result");

        // ✅ حالة OTP
        if (result['status'] == 'otp_sent') {
          Get.snackbar("تحقق مطلوب", result['message'] ?? "تم إرسال رمز التحقق");
          Get.toNamed('/otp', arguments: {
            'identifier': result['channel'] == 'email'
                ? emailController.text.trim()
                : phoneController.text.trim(),
            'password': passwordController.text.trim(),
            'channel': result['channel'],
            'dest': result['dest'],
          });
          return;
        }

        // ✅ حالة نجاح عادي
        Get.snackbar("نجاح", "تم إنشاء الحساب بنجاح");
        Get.offAllNamed('/login');

      } catch (e) {
        Get.snackbar("خطأ", e.toString(), backgroundColor: Colors.red.shade100);
      } finally {
        setState(() => _loading = false);
      }
    } else if (_selectedDate == null) {
      Get.snackbar("تنبيه", "يرجى اختيار تاريخ الميلاد");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeInDown(
                duration: const Duration(milliseconds: 1000),
                child: const Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                ),
              ),
               _buildRoleSelector(),



              const SizedBox(height: 20),
              _buildTextField("Full Name", controller: nameController),
              _buildTextField("Email", controller: emailController),
              _buildTextField("Phone Number", controller: phoneController),
              _buildPasswordField(),
              _buildConfirmPasswordField(),

              FadeInUp(
                duration: const Duration(milliseconds: 1500),
                child: GestureDetector(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime(2000),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      setState(() => _selectedDate = pickedDate);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey)),
                    ),
                    child: Text(
                      _selectedDate == null
                          ? "Date of Birth"
                          : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                      style: TextStyle(color: Colors.grey[700], fontSize: 16),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              FadeInUp(
                duration: const Duration(milliseconds: 1600),
                child: Row(
                  children: [
                    Checkbox(
                      value: _agreeToTerms,
                      onChanged: (val) => setState(() => _agreeToTerms = val!),
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          text: 'I agree to the ',
                          style: const TextStyle(fontSize: 13, color: Colors.black),
                          children: [
                            TextSpan(
                              text: 'Terms and Conditions',
                              style: const TextStyle(color: Colors.deepPurple, decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Get.to(() => const TermsPage()),
                            ),
                            const TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: const TextStyle(color: Colors.deepPurple, decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Get.to(() => const PrivacyPage()),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              FadeInUp(
                duration: const Duration(milliseconds: 1700),
                child: ElevatedButton(
                  onPressed: _agreeToTerms && !_loading ? _register : null,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 45),
                    backgroundColor: Colors.deepPurple,
                  ),
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Create Account", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 20),
              FadeInUp(
                duration: const Duration(milliseconds: 1800),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account? "),
                      GestureDetector(
                        onTap: () => Get.off(() => const LoginPage()),
                        child: const Text("Login", style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, {required TextEditingController controller}) {
    return FadeInUp(
      duration: const Duration(milliseconds: 1300),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[700]),
            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.purple)),
          ),
          validator: (val) => val == null || val.isEmpty ? 'Required' : null,
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return FadeInUp(
      duration: const Duration(milliseconds: 1300),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextFormField(
          controller: passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            hintText: "Password",
            hintStyle: TextStyle(color: Colors.grey[700]),
            suffixIcon: IconButton(
              icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.purple)),
          ),
          validator: (val) {
            if (val == null || val.isEmpty) return 'Required';
            if (!_isPasswordValid(val)) return 'Must start with uppercase & be at least 8 chars';
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildConfirmPasswordField() {
    return FadeInUp(
      duration: const Duration(milliseconds: 1300),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextFormField(
          controller: confirmPasswordController,
          obscureText: _obscureConfirm,
          decoration: InputDecoration(
            hintText: "Confirm Password",
            hintStyle: TextStyle(color: Colors.grey[700]),
            suffixIcon: IconButton(
              icon: Icon(_obscureConfirm ? Icons.visibility : Icons.visibility_off),
              onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
            ),
            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.purple)),
          ),
          validator: (val) {
            if (val == null || val.isEmpty) return 'Required';
            if (val != passwordController.text) return 'Passwords do not match';
            return null;
          },
        ),
      ),
    );
  }
  Widget _buildRoleSelector() {
    final options = const {
      'patient': 'مريض',
      'doctor' : 'طبيب',
    };

    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF3E8FF), // بنفسجي فاتح
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.deepPurple.shade200),
        ),
        padding: const EdgeInsets.all(6),
        child: Row(
          children: options.entries.map((e) {
            final selected = _role == e.key;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _role = e.key),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: selected ? Colors.deepPurple : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    e.value,
                    style: TextStyle(
                      color: selected ? Colors.white : Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

}