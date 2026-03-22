import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_lanka/core/constants/app_assets.dart';
import 'package:ride_lanka/core/constants/app_colors.dart';
import 'package:ride_lanka/features/auth/providers/meta_data_provider.dart';
import 'package:ride_lanka/features/auth/widgets/budget_tab_switch.dart';
import 'package:ride_lanka/widgets/primary_button.dart';

class MetaDataScreen extends StatefulWidget {
  const MetaDataScreen({super.key});

  @override
  State<MetaDataScreen> createState() => _MetaDataScreenState();
}

class _MetaDataScreenState extends State<MetaDataScreen> {
  List<String> interests = [
    'Hiking',
    'Adventure',
    'Wildlife',
    'Culture',
    'Food & Dining',
    'Nightlife',
    'Relaxation',
  ];

  List<String> travelStyles = [
    'Solo Travel',
    'Couple Travel',
    'Family Travel',
    'Friends Travel',
  ];

  Widget horizontalStepper(MetaDataProvider provider) {
    bool step1Done = provider.selectedInterests.isNotEmpty;
    bool step2Done = provider.travelType != null;
    bool step3Done = provider.budget != null;

    Color getColor(bool completed) =>
        completed ? AppColors.primaryColor : AppColors.chipBackground;

    return Row(
      children: [
        Column(
          children: [
            CircleAvatar(
              radius: 12,
              backgroundColor: getColor(step1Done),
              child: const Icon(Icons.check, size: 16, color: Colors.white),
            ),
            const SizedBox(height: 4),
            const Text('Interests', style: TextStyle(fontSize: 12)),
          ],
        ),

        Expanded(
          child: Container(
            height: 2,
            color: step1Done
                ? AppColors.lowPrimaryColor
                : AppColors.chipBackground,
          ),
        ),

        Column(
          children: [
            CircleAvatar(
              radius: 12,
              backgroundColor: getColor(step2Done),
              child: const Icon(Icons.check, size: 16, color: Colors.white),
            ),
            const SizedBox(height: 4),
            const Text('Travel', style: TextStyle(fontSize: 12)),
          ],
        ),

        Expanded(
          child: Container(
            height: 2,
            color: step2Done
                ? AppColors.lowPrimaryColor
                : AppColors.chipBackground,
          ),
        ),

        Column(
          children: [
            CircleAvatar(
              radius: 12,
              backgroundColor: getColor(step3Done),
              child: const Icon(Icons.check, size: 16, color: Colors.white),
            ),
            const SizedBox(height: 4),
            const Text('Budget', style: TextStyle(fontSize: 12)),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MetaDataProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: AppColors.white,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        AppAssets.logo,
                        color: AppColors.black,
                        height: 30,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Ride\nLanka',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  horizontalStepper(provider),
                  const SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Tell us what you love',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'We’ll use this to personalize your Sri Lankan\ntravel experience from peaks to placing.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          const Text(
                            'Your interests',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: interests.map((interest) {
                              final selected = provider.selectedInterests
                                  .contains(interest);
                              return GestureDetector(
                                onTap: () => provider.toggleInterest(interest),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? AppColors.lowPrimaryColor
                                        : AppColors.chipBackground,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    interest,
                                    style: TextStyle(
                                      color: selected
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),

                          const SizedBox(height: 30),

                          const Text(
                            'Travel Style',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: travelStyles.map((style) {
                              final selected = provider.travelType == style;
                              return GestureDetector(
                                onTap: () => provider.setTravelType(style),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? AppColors.lowPrimaryColor
                                        : AppColors.chipBackground,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    style,
                                    style: TextStyle(
                                      color: selected
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),

                          const SizedBox(height: 30),

                          const Text(
                            'Budget Preference',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 20),
                          BudgetTabSwitch(
                            values: const ['Low', 'Medium', 'Premium'],
                            onToggleCallback: (index) {
                              provider.setBudget(
                                ['Low', 'Medium', 'Premium'][index],
                              );
                            },
                          ),

                          const SizedBox(height: 40),

                          provider.isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.primaryColor,
                                  ),
                                )
                              : PrimaryButton(
                                  buttonText: 'Continue',
                                  onPressed: provider.isValid
                                      ? () => provider.saveUser(context)
                                      : null,
                                ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
