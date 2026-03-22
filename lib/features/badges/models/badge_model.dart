class BadgeModel {
  final String title;
  final String description;
  final String imageUrl;
  final String badgeType; // 'gold', 'silver', 'bronze'
  final String earnedDate;

  const BadgeModel({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.badgeType,
    required this.earnedDate,
  });
}