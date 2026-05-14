import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../state/app_bootstrap.dart';
import '../../widgets/gradient_background.dart';
import '../home/home_screen.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bootstrap = ref.watch(appBootstrapProvider);

    bootstrap.when(
      data: (_) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        });
      },
      loading: () {},
      error: (e, st) {},
    );

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.primaryGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.neonPink.withValues(alpha: 0.6),
                      blurRadius: 40,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(Icons.speed_rounded, size: 84, color: Colors.white),
              )
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .scaleXY(end: 1.05, duration: 1200.ms, curve: Curves.easeInOut),
              const SizedBox(height: 32),
              Text(
                'NITRORUSH',
                style: AppTextStyles.displayLarge.copyWith(
                  fontSize: 42,
                  shadows: [
                    Shadow(color: AppColors.neonPink.withValues(alpha: 0.8), blurRadius: 30),
                  ],
                ),
              ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2),
              const SizedBox(height: 8),
              Text(
                'TRAFFIC ESCAPE',
                style: AppTextStyles.headlineSmall.copyWith(
                  letterSpacing: 8,
                  color: AppColors.neonBlue,
                ),
              ).animate().fadeIn(duration: 800.ms, delay: 200.ms),
              const SizedBox(height: 48),
              const SizedBox(
                width: 200,
                child: LinearProgressIndicator(
                  backgroundColor: Color(0x33FFFFFF),
                  valueColor: AlwaysStoppedAnimation(AppColors.neonPink),
                ),
              ),
              const SizedBox(height: 16),
              if (bootstrap.hasError)
                Text(
                  'Error: ${bootstrap.error}',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.danger),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
