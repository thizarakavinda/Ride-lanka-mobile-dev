import 'package:flutter/material.dart';
import 'package:ride_lanka/core/constants/app_colors.dart';
import 'package:ride_lanka/features/quests/data/quest_data.dart';
import 'package:ride_lanka/features/quests/widgets/quest_card.dart';
import 'package:ride_lanka/widgets/custom_search_bar.dart';

class QuestsScreen extends StatelessWidget {
  const QuestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quests = QuestData.quests;
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

              Text(
                '${quests.length} Quests Available',
                style: TextStyle(
                  fontSize: (sw * 0.034).clamp(12.0, 15.0),
                  color: AppColors.dividerText,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: ListView.separated(
                  itemCount: quests.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    return QuestCard(quest: quests[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
