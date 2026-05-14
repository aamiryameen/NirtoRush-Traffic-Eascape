import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/enums.dart';
import '../../../state/settings_provider.dart';
import '../../widgets/cards/glass_card.dart';
import '../../widgets/gradient_background.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: Text('Settings', style: AppTextStyles.headlineMedium)),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _section('Audio'),
            GlassCard(
              child: Column(children: [
                _slider(
                  label: 'Music',
                  value: settings.musicVolume,
                  onChanged: (v) => notifier.update(settings.copyWith(musicVolume: v)),
                ),
                _slider(
                  label: 'Sound FX',
                  value: settings.sfxVolume,
                  onChanged: (v) => notifier.update(settings.copyWith(sfxVolume: v)),
                ),
              ]),
            ),
            const SizedBox(height: 16),
            _section('Controls'),
            GlassCard(
              child: Column(children: [
                _controlOption(
                  context,
                  current: settings.controlScheme,
                  onChanged: (s) => notifier.update(settings.copyWith(controlScheme: s)),
                ),
                const Divider(),
                SwitchListTile(
                  value: settings.vibrationEnabled,
                  activeThumbColor: AppColors.neonPink,
                  onChanged: (v) => notifier.update(settings.copyWith(vibrationEnabled: v)),
                  title: const Text('Vibration'),
                ),
                SwitchListTile(
                  value: settings.autoNitro,
                  activeThumbColor: AppColors.neonPink,
                  onChanged: (v) => notifier.update(settings.copyWith(autoNitro: v)),
                  title: const Text('Auto Nitro'),
                  subtitle: const Text('Auto-trigger nitro when full'),
                ),
              ]),
            ),
            const SizedBox(height: 16),
            _section('Display'),
            GlassCard(
              child: Column(children: [
                SwitchListTile(
                  value: settings.showFps,
                  activeThumbColor: AppColors.neonPink,
                  onChanged: (v) => notifier.update(settings.copyWith(showFps: v)),
                  title: const Text('Show FPS'),
                ),
                SwitchListTile(
                  value: settings.reducedMotion,
                  activeThumbColor: AppColors.neonPink,
                  onChanged: (v) => notifier.update(settings.copyWith(reducedMotion: v)),
                  title: const Text('Reduced motion'),
                  subtitle: const Text('Less screen shake & particle FX'),
                ),
              ]),
            ),
            const SizedBox(height: 24),
            _section('About'),
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: const Text('Version'),
                    trailing: Text(AppConstants.appVersion,
                        style: AppTextStyles.caption),
                  ),
                  ListTile(
                    title: const Text('Support'),
                    trailing: Text(AppConstants.supportEmail,
                        style: AppTextStyles.caption),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(String label) => Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 4),
        child: Text(label.toUpperCase(),
            style: AppTextStyles.caption.copyWith(letterSpacing: 4)),
      );

  Widget _slider({
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return ListTile(
      title: Text(label, style: AppTextStyles.bodyMedium),
      subtitle: Slider(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.neonPink,
        inactiveColor: AppColors.bgMid,
      ),
      trailing: Text('${(value * 100).round()}%', style: AppTextStyles.caption),
    );
  }

  Widget _controlOption(
    BuildContext context, {
    required ControlScheme current,
    required ValueChanged<ControlScheme> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Column(children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text('Control scheme',
              style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: ControlScheme.values.map((s) {
            final sel = s == current;
            return ChoiceChip(
              selected: sel,
              label: Text(s.name),
              onSelected: (_) => onChanged(s),
              selectedColor: AppColors.neonPink,
              backgroundColor: AppColors.bgMid,
            );
          }).toList(),
        ),
      ]),
    );
  }
}
