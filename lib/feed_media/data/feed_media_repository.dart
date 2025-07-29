import 'package:flutter_feed_media/feed_media/models/feed_media_model.dart';

class FeedMediaRepository {
  Future<List<FeedMediaModel>> fetchMedia(int page) async {
    // Mock data for now
    await Future.delayed(const Duration(seconds: 1));
    return List.generate(
      10,
      (index) {
        final id = page * 10 + index;
        return FeedMediaModel(
          id: 'id_$id',
          type: index % 2 == 0 ? 'video' : 'image',
          url: index % 2 == 0
              ? 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4'
              : 'https://picsum.photos/seed/$id/400/600',
          coverUrl: 'https://picsum.photos/seed/$id/400/600',
          title: '@Author - Title $id',
          description: 'This is a description for media item #$id. #hashtag',
          topics: ['#Topic${id % 3}', '#Trending'],
          imageUrls: index % 2 != 0
              ? [
                  'https://picsum.photos/seed/$id/400/600',
                  'https://picsum.photos/seed/${id + 1}/400/600',
                  'https://picsum.photos/seed/${id + 2}/400/600',
                ]
              : null,
        );
      },
    );
  }
}
