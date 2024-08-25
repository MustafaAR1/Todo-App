import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/Auth/auth_controller.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final _authController = Get.find<AuthController>();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome To Post App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Image.asset(
                          'assets/post_asset.png',
                          height: 100,
                          width: 100,
                          fit: BoxFit.fitHeight,
                        ),
                        const SizedBox(height: 35),
            
            ElevatedButton.icon(
              onPressed: () async {
                await _authController.signInWithGoogle();
              },
              icon: Image.asset(
                'assets/google_logo.png',
                height: 24,
              ),
              label: const Text('Sign in with Google'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
