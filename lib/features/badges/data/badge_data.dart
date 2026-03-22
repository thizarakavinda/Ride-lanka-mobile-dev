import 'package:ride_lanka/features/badges/models/badge_model.dart';

class BadgeData {
  static const List<BadgeModel> badges = [
    BadgeModel(
      title: 'Camped Knuckles',
      description:
          'The highest mountain in Sri Lanka, standing at 2,524 meters above sea level.',
      imageUrl: 'https://moonlaser.com/BKP/images/keith_4.1b.jpg',
      badgeType: 'silver',
      earnedDate: '2026.03.22',
    ),
    BadgeModel(
      title: 'Beach Explorer',
      description:
          'Visited 5 stunning beaches along the southern coast of Sri Lanka.',
      imageUrl:
          'https://www.shutterstock.com/image-vector/frontier-beach-camp-logo-vintage-260nw-2736064155.jpg',
      badgeType: 'gold',
      earnedDate: '2026.02.14',
    ),
    BadgeModel(
      title: 'Culture Seeker',
      description:
          'Explored the ancient city of Sigiriya and its historic rock fortress.',
      imageUrl:
          'https://iconlogovector.com/uploads/images/2024/03/lg-65f6b3b8b4f4e-MAJELIS-ULAMA-INDONESIA.webp',
      badgeType: 'bronze',
      earnedDate: '2026.01.05',
    ),
  ];
}
