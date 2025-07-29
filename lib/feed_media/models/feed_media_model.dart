
class FeedMediaModel {
  final String id;
  final String type; // 'video' or 'image'
  final String url; // For video, or single image fallback
  final String coverUrl;
  final String title;
  final String description;
  final List<String> topics;
  final List<String>? imageUrls; // For multiple images

  FeedMediaModel({
    required this.id,
    required this.type,
    required this.url,
    required this.coverUrl,
    required this.title,
    required this.description,
    this.topics = const [],
    this.imageUrls,
  });
}
