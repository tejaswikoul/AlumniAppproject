import 'package:demo_alumnet/components/widgets.dart';
import 'package:demo_alumnet/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({Key? key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Sign in user
  Future<void> signIn() async {
    // Get the auth service
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signInWithEmailAndPassword(
          emailController.text, passwordController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple[200]!, Colors.deepPurple[400]!],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Stack to overlay circular logo on the gradient background
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Circular logo image
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage('assets/Vesitlogo.png'),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  const Text(
                    'VESlumni',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  const Text(
                    'Welcome back, student!!',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),

                  const SizedBox(
                    height: 50,
                  ),

                  // Email
                  MyTextField(
                    controller: emailController,
                    hintText: 'Enter your email',
                    labelText: 'Email',
                    obscureText: false,
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  // Password
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    labelText: 'Password',
                    obscureText: true,
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  // Sign in button
                  MyCustomBtn(onTap: signIn, text: "Sign In"),

                  const SizedBox(
                    height: 40,
                  ),

                  // Already a member? Sign In
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Not a member?'),
                      const SizedBox(
                        width: 4,
                      ),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          'Register Now',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
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
      ),
    );
  }
}
