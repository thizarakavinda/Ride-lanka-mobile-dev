import 'package:flutter/material.dart';
import 'package:ride_lanka/core/constants/app_colors.dart';

class ProfileInfo extends StatelessWidget {
  final String imageUrl;
  final String userName;
  final String? userEmail;
  final VoidCallback? onLogout;
  final VoidCallback? onEditProfile;

  const ProfileInfo({
    super.key,
    required this.imageUrl,
    required this.userName,
    this.userEmail,
    this.onLogout,
    this.onEditProfile,
  });

  @override
  Widget build(BuildContext context) {
    final double avatarRadius = (MediaQuery.of(context).size.width * 0.09)
        .clamp(30.0, 50.0);

    return Row(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: avatarRadius,
              backgroundImage: NetworkImage(imageUrl),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: onEditProfile,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                userEmail ?? '',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: onLogout,
          icon: const Icon(
            Icons.logout,
            size: 28,
            color: AppColors.favoriteColor,
          ),
        ),
      ],
    );
  }
}
