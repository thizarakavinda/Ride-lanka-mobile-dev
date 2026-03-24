class ExplorePlaceModel {
  final String id;
  final String title;
  final String snippet;
  final String content;
  final String imageUrl;
  final String createdAt;

  ExplorePlaceModel({
    required this.id,
    required this.title,
    required this.snippet,
    required this.content,
    required this.imageUrl,
    required this.createdAt,
  });

  factory ExplorePlaceModel.fromMap(String id, Map<String, dynamic> data) {
    return ExplorePlaceModel(
      id: id,
      title: data['title'] ?? 'Unknown',
      snippet: data['snippet'] ?? '',
      content: data['content'] ?? '',
      imageUrl: data['image'] ?? '',
      createdAt: data['createdAt'] ?? '',
    );
  }
}
