import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_lanka/core/constants/app_colors.dart';
import 'package:ride_lanka/features/auth/providers/auth_provider.dart';
import 'package:ride_lanka/features/profile/widgets/profile_info.dart';
import 'package:ride_lanka/features/profile/widgets/profile_summary_row.dart';
import 'package:ride_lanka/features/profile/widgets/badges_card.dart';
import 'package:ride_lanka/features/profile/widgets/setting_card.dart';
import 'package:ride_lanka/routes/app_routes.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: const Text(
          'Profile',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileInfo(
                imageUrl:
                    'https://scontent-sin11-2.xx.fbcdn.net/v/t39.30808-1/627147155_882953857856540_4496525664149994015_n.jpg?stp=dst-jpg_s200x200_tt6&_nc_cat=101&ccb=1-7&_nc_sid=e99d92&_nc_ohc=EoEvd2yp8ZwQ7kNvwGAdM65&_nc_oc=AdpT9lyZY5CggScPmy0rG9ng-2pwMRJy_8a353t013HX2yv3gRB5eYNd-gl1pA4n_JY&_nc_zt=24&_nc_ht=scontent-sin11-2.xx&_nc_gid=OAPOyEL0W7HGPoMFwtUqyw&_nc_ss=7a32e&oh=00_Afy_8WYXJwz-XRigEm_4e1mLVB5UIn1lKWgoU2Zsoc0KlQ&oe=69C5A1F5',
                userName: 'Thisara Kavinda',
                userEmail: 'thisarakavinda25@gmail.com',
                onLogout: () {
                  Provider.of<AuthController>(
                    context,
                    listen: false,
                  ).signOut(context);
                },
                onEditProfile: () {},
              ),

              const SizedBox(height: 30),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ProfileSummaryRow(),

                      const SizedBox(height: 30),

                      const Text(
                        'Badges',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 20),

                      BadgesCard(
                        badgeImageUrl:
                            'https://cdn-icons-png.flaticon.com/512/616/616408.png',
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.badgesInfo);
                        },
                      ),

                      const SizedBox(height: 20),

                      SettingCard(
                        settingTitle: 'Quests',
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.quests);
                        },
                      ),

                      const SizedBox(height: 30),

                      const Text(
                        'Settings',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 20),

                      SettingCard(settingTitle: 'Edit Profile', onTap: () {}),
                      SettingCard(settingTitle: 'Edit Language', onTap: () {}),
                      SettingCard(
                        settingTitle: 'Terms and Conditions',
                        onTap: () {},
                      ),
                      SettingCard(settingTitle: 'Privacy Policy', onTap: () {}),

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
  }
}
