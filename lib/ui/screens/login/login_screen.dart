import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../widgets/buttons/neon_button.dart';
import '../../widgets/gradient_background.dart';
import '../home/home_screen.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Icon(Icons.directions_car_filled,
                    size: 120, color: AppColors.neonPink.withValues(alpha: 0.9)),
                const SizedBox(height: 24),
                Text(
                  'Welcome, Driver',
                  style: AppTextStyles.displaySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose how you want to play',
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const Spacer(flex: 2),
                NeonButton(
                  label: 'Continue as Guest',
                  icon: Icons.flash_on,
                  expand: true,
                  onTap: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                  ),
                ),
                const SizedBox(height: 14),
                NeonButton(
                  label: 'Sign in with Google',
                  icon: Icons.g_mobiledata,
                  style: NeonButtonStyle.ghost,
                  expand: true,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                          'Google sign-in requires Supabase OAuth setup. See lib/services/auth_service.dart'),
                    ));
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  'Cloud sync available with Google sign-in',
                  style: AppTextStyles.caption,
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
