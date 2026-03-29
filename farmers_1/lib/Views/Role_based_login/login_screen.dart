//
import 'package:farmers_1/Services/auth_service.dart';
import 'package:farmers_1/Views/Role_based_login/Admin/Screen/admin_home_screen.dart';
import 'package:farmers_1/Views/Role_based_login/User/Screen/user_app_main_screen.dart';
import 'package:farmers_1/Views/Role_based_login/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:farmers_1/Core/Common/app_localizations_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String _selectedRole = 'User'; // default role
  String? _roleError; // role validation error
  bool _isLoading = false;
  bool isPasswordHidden = true;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _roleError = null; // reset role error
    });

    try {
      String? result = await _authService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        role: _selectedRole, // pass selected role
      );

      setState(() => _isLoading = false);

      if (result == 'Admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminHomeScreen()),
        );
      } else if (result == 'User') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const UserAppMainScreen()),
        );
      } else if (result == "Selected role does not match your account role") {
        // role mismatch validation
        final l10n = AppLocalizationsHelper.of(context);
        setState(() => _roleError = l10n.accountNotRole(_selectedRole));
      } else if (result != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result)));
      }
    } catch (e) {
      setState(() => _isLoading = false);
      final l10n = AppLocalizationsHelper.of(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.error(e.toString()))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsHelper.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Image.asset("assets/3094352.jpg"),
                const SizedBox(height: 20),

                // Email field
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: l10n.email,
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.emailRequired;
                    }
                    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                    if (!emailRegex.hasMatch(value)) {
                      return l10n.validEmail;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password field
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: l10n.password,
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() => isPasswordHidden = !isPasswordHidden);
                      },
                      icon: Icon(
                        isPasswordHidden
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                  ),
                  obscureText: isPasswordHidden,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.passwordRequired;
                    }
                    if (value.length < 6) {
                      return l10n.passwordMinLength;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Role dropdown
                DropdownButtonFormField<String>(
                  value: _selectedRole,
                  decoration: InputDecoration(
                    labelText: l10n.selectRole,
                    border: const OutlineInputBorder(),
                    errorText: _roleError, // display role error
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRole = newValue!;
                      _roleError = null; // clear error on change
                    });
                  },
                  items: [
                    DropdownMenuItem(value: 'Admin', child: Text(l10n.admin)),
                    DropdownMenuItem(value: 'User', child: Text(l10n.user)),
                  ],
                ),
                const SizedBox(height: 20),

                _isLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _login,
                          child: Text(l10n.login),
                        ),
                      ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      l10n.dontHaveAccount,
                      style: const TextStyle(fontSize: 18),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SignupScreen(),
                          ),
                        );
                      },
                      child: Text(
                        l10n.signupHere,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          letterSpacing: -1,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
