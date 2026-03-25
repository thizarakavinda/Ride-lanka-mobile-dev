import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_lanka/core/constants/app_colors.dart';
import 'package:ride_lanka/features/quests/providers/quests_provider.dart';

import 'package:ride_lanka/features/quests/widgets/quest_card.dart';
import 'package:ride_lanka/widgets/custom_search_bar.dart'; // Make sure this path is right!

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

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final double hPadding = (sw * 0.05).clamp(16.0, 28.0);

    return Scaffold(
      appBar: AppBar(
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
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomSearchBar(searchBoxHint: 'Search quests...'),
              const SizedBox(height: 20),

              Consumer<QuestProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(color: Colors.teal),
                      ),
                    );
                  }

                  if (provider.allQuests.isEmpty) {
                    return const Expanded(
                      child: Center(child: Text('No quests available.')),
                    );
                  }

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
                              final status = provider.getStatusForQuest(
                                quest.id,
                              );
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
      ),
    );
  }
}
