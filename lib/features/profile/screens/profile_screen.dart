import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_lanka/features/edit%20profile/providers/profile_provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ride_lanka/core/constants/app_colors.dart';
import 'package:ride_lanka/features/auth/providers/auth_provider.dart';
import 'package:ride_lanka/features/home/providers/home_provider.dart';
import 'package:ride_lanka/features/profile/widgets/profile_header.dart';
import 'package:ride_lanka/features/profile/widgets/profile_stats_row.dart';
import 'package:ride_lanka/features/profile/widgets/profile_section_title.dart';
import 'package:ride_lanka/features/profile/widgets/profile_setting_tile.dart';
import 'package:ride_lanka/features/profile/widgets/badges_card.dart';
import 'package:ride_lanka/features/quests/providers/quests_provider.dart';
import 'package:ride_lanka/routes/app_routes.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<QuestProvider>(context, listen: false).fetchQuestsData();
      Provider.of<ProfileProvider>(context, listen: false).loadProfile();
    });
  }

  Widget _buildBadgesShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: List.generate(4, (_) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  width: 46,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: IconButton(
              onPressed: () {},
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.searchBoxBorder),
                ),
                child: const Icon(
                  Icons.notifications_outlined,
                  size: 20,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              // ── Profile Header with XP bar ──────────────────────────────
              Consumer<ProfileProvider>(
                builder: (context, profileProvider, _) {
                  return ProfileHeader(
                    imageUrl: profileProvider.photoUrl.isNotEmpty
                        ? profileProvider.photoUrl
                        : homeProvider.userEmail, // fallback
                    userName: profileProvider.name.isNotEmpty
                        ? profileProvider.name
                        : homeProvider.userName,
                    userEmail: homeProvider.userEmail,
                    xp: profileProvider.xp, // TODO: wire real XP
                    onLogout: () {
                      Provider.of<AuthController>(
                        context,
                        listen: false,
                      ).signOut(context);
                    },
                    onEditProfile: () {
                      Navigator.pushNamed(context, AppRoutes.editProfile);
                    },
                  );
                },
              ),

              const SizedBox(height: 24),

              // ── Stats row ───────────────────────────────────────────────
              const ProfileStatsRow(),

              const SizedBox(height: 28),

              // ── Badges section ──────────────────────────────────────────
              ProfileSectionTitle(
                title: 'My Badges',
                actionLabel: 'See All',
                onAction: () =>
                    Navigator.pushNamed(context, AppRoutes.badgesInfo),
              ),

              const SizedBox(height: 14),

              Consumer<QuestProvider>(
                builder: (context, questProvider, _) {
                  if (questProvider.isLoading) {
                    return _buildBadgesShimmer();
                  }
                  return BadgesCard(
                    badges: questProvider.completedQuestBadges,
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.badgesInfo),
                  );
                },
              ),

              const SizedBox(height: 28),

              // ── Activity section ────────────────────────────────────────
              const ProfileSectionTitle(title: 'Activity'),
              const SizedBox(height: 14),

              ProfileSettingTile(
                icon: Icons.map_rounded,
                title: 'My Trips',
                subtitle: 'View your planned & completed trips',
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.tripHistory),
              ),
              ProfileSettingTile(
                icon: Icons.emoji_events_rounded,
                title: 'Quests',
                subtitle: 'Complete quests to earn XP & badges',
                iconColor: Colors.orange,
                onTap: () => Navigator.pushNamed(context, AppRoutes.quests),
              ),
              ProfileSettingTile(
                icon: Icons.favorite_rounded,
                title: 'Favourites',
                subtitle: 'Places you have saved',
                iconColor: Colors.redAccent,
                onTap: () {},
              ),

              const SizedBox(height: 28),

              // ── Settings section ────────────────────────────────────────
              const ProfileSectionTitle(title: 'Settings'),
              const SizedBox(height: 14),

              ProfileSettingTile(
                icon: Icons.person_rounded,
                title: 'Edit Profile',
                subtitle: 'Update your name and photo',
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.editProfile);
                },
              ),
              ProfileSettingTile(
                icon: Icons.language_rounded,
                title: 'Language',
                subtitle: 'English',
                onTap: () {},
              ),
              ProfileSettingTile(
                icon: Icons.description_rounded,
                title: 'Terms and Conditions',
                onTap: () {},
              ),
              ProfileSettingTile(
                icon: Icons.privacy_tip_rounded,
                title: 'Privacy Policy',
                onTap: () {},
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
