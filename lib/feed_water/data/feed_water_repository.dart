// feed_water_repository.dart
import '../models/feed_water_model.dart';

class FeedWaterRepository {
  Future<List<FeedWaterItemModel>> fetchWaterFlowData(int page) async {
    // 模拟数据获取，这里可以替换为实际的网络请求或本地数据源
    await Future.delayed(const Duration(seconds: 1));
    return List.generate(
      20, // 每页20个数据
      (index) {
        final id = page * 20 + index;
        final isVideo = index % 3 == 0; // 模拟视频和图片
        final isAd = index % 7 == 0; // 模拟广告

        return FeedWaterItemModel(
          id: 'water_item_$id',
          type: isAd ? 'ad' : (isVideo ? 'video' : 'image'),
          imageUrl: 'https://picsum.photos/seed/$id/300/${300 + (id % 100)}', // 模拟不同高度
          videoUrl: isVideo ? 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4' : null,
          title: isAd ? '广告标题 $id' : '瀑布流标题 $id',
          description: '这是瀑布流项目的描述信息 $id。',
          aspectRatio: 300 / (300 + (id % 100)), // 模拟不同宽高比
          author: '作者 $id',
          avatarUrl: 'https://picsum.photos/seed/avatar_$id/100/100',
          likes: 100 + (id * 5),
          isLiked: id % 2 == 0,
          tags: ['标签${id % 3}', '热门'],
        );
      },
    );
  }
}
