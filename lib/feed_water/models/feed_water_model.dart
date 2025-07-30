// feed_water_model.dart
class FeedWaterItemModel {
  final String id;
  final String type; // 例如: 'image', 'video', 'ad'
  final String imageUrl;
  final String? videoUrl; // 视频类型可能需要
  final String title;
  final String description;
  final double aspectRatio; // 用于瀑布流布局，表示宽高比
  final String? author;
  final String? avatarUrl;
  final int? likes;
  final bool isLiked;
  final List<String> tags;

  FeedWaterItemModel({
    required this.id,
    required this.type,
    required this.imageUrl,
    this.videoUrl,
    required this.title,
    required this.description,
    required this.aspectRatio,
    this.author,
    this.avatarUrl,
    this.likes,
    this.isLiked = false,
    this.tags = const [],
  });

  // 方便数据转换的工厂方法 (可选)
  factory FeedWaterItemModel.fromJson(Map<String, dynamic> json) {
    return FeedWaterItemModel(
      id: json['id'],
      type: json['type'],
      imageUrl: json['imageUrl'],
      videoUrl: json['videoUrl'],
      title: json['title'],
      description: json['description'],
      aspectRatio: json['aspectRatio']?.toDouble() ?? 1.0,
      author: json['author'],
      avatarUrl: json['avatarUrl'],
      likes: json['likes'],
      isLiked: json['isLiked'] ?? false,
      tags: List<String>.from(json['tags'] ?? []),
    );
  }
}
