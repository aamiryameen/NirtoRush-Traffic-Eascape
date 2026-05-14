import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/leaderboard_entry.dart';
import '../../../services/supabase_service.dart';
import '../../widgets/cards/glass_card.dart';
import '../../widgets/gradient_background.dart';

final _leaderboardProvider = FutureProvider.autoDispose
    .family<List<LeaderboardEntry>, String>((ref, scope) async {
  return SupabaseService.instance.fetchLeaderboard(scope: scope, limit: 50);
});

class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 3, vsync: this);
  static const _scopes = ['global', 'country', 'friends'];

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Leaderboard', style: AppTextStyles.headlineMedium),
          bottom: TabBar(
            controller: _tabs,
            indicatorColor: AppColors.neonPink,
            labelColor: AppColors.neonPink,
            unselectedLabelColor: AppColors.textMuted,
            tabs: const [
              Tab(text: 'Global'),
              Tab(text: 'Country'),
              Tab(text: 'Friends'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabs,
          children: _scopes.map(_buildList).toList(),
        ),
      ),
    );
  }

  Widget _buildList(String scope) {
    final async = ref.watch(_leaderboardProvider(scope));
    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error: $e', style: AppTextStyles.bodyMedium)),
      data: (entries) {
        if (entries.isEmpty) {
          return Center(child: Text('No entries yet', style: AppTextStyles.bodyMedium));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: entries.length,
          itemBuilder: (context, i) {
            final e = entries[i];
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GlassCard(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                borderColor: i < 3 ? AppColors.neonYellow.withValues(alpha: 0.6) : null,
                child: Row(
                  children: [
                    SizedBox(
                      width: 36,
                      child: Text('#${e.rank}',
                          style: AppTextStyles.headlineSmall.copyWith(
                              color: i < 3 ? AppColors.neonYellow : AppColors.textMuted)),
                    ),
                    CircleAvatar(
                      backgroundColor: AppColors.surfaceElevated,
                      child: Text(e.username.characters.first),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(e.username, style: AppTextStyles.bodyLarge),
                          Text('Lvl ${e.level} • ${e.countryCode ?? "—"}',
                              style: AppTextStyles.caption),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(Formatters.compactNumber(e.score),
                            style: AppTextStyles.headlineSmall
                                .copyWith(color: AppColors.neonYellow)),
                        Text(Formatters.distance(e.distance),
                            style: AppTextStyles.caption),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
