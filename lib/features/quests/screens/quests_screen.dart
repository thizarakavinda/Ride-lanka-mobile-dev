import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ride_lanka/core/constants/app_colors.dart';
import 'package:ride_lanka/features/quests/providers/quests_provider.dart';
import 'package:ride_lanka/features/quests/widgets/quest_card.dart';
import 'package:ride_lanka/widgets/custom_search_bar.dart';

class QuestsScreen extends StatefulWidget {
  const QuestsScreen({super.key});

  @override
  State<QuestsScreen> createState() => _QuestsScreenState();
}

class _QuestsScreenState extends State<QuestsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<QuestProvider>(context, listen: false).fetchQuestsData();
    });
  }

  Widget _buildShimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row — avatar + title + reward chip
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badge circle
                Container(
                  width: 58,
                  height: 58,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // Title bar
                          Expanded(
                            child: Container(
                              height: 14,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Reward chip
                          Container(
                            width: 60,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Description line 1
                      Container(
                        height: 10,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Description line 2
                      Container(
                        height: 10,
                        width: 180,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),
            Divider(height: 1, color: Colors.grey.shade100),
            const SizedBox(height: 10),

            // Chips row
            Row(
              children: List.generate(4, (i) {
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  width: 60 + (i * 8.0),
                  height: 22,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                );
              }),
            ),

            const SizedBox(height: 10),
            Divider(height: 1, color: Colors.grey.shade100),
            const SizedBox(height: 10),

            // Status + button row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Status
                Container(
                  width: 120,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                // Button
                Container(
                  width: 90,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final double hPadding = (sw * 0.05).clamp(16.0, 28.0);

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Quests',
          style: TextStyle(
            fontSize: (sw * 0.062).clamp(20.0, 28.0),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      backgroundColor: AppColors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomSearchBar(searchBoxHint: 'Search quests...'),
            const SizedBox(height: 20),

            Consumer<QuestProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return Expanded(
                    child: ListView.separated(
                      itemCount: 4,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (_, __) => _buildShimmerCard(),
                    ),
                  );
                }

                if (provider.allQuests.isEmpty) {
                  return const Expanded(
                    child: Center(
                      child: Text(
                        'No quests available.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                }

                // ── Quests list ──────────────────────────────────────────────
                return Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${provider.allQuests.length} Quests Available',
                        style: TextStyle(
                          fontSize: (sw * 0.034).clamp(12.0, 15.0),
                          color: AppColors.dividerText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.separated(
                          itemCount: provider.allQuests.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 14),
                          itemBuilder: (context, index) {
                            final quest = provider.allQuests[index];
                            final status = provider.getStatusForQuest(quest.id);
                            return QuestCard(quest: quest, status: status);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
