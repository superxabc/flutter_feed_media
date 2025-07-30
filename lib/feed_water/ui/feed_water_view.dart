// feed_water_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../providers/feed_water_provider.dart';
import 'feed_water_card.dart';

class FeedWaterView extends ConsumerWidget {
  const FeedWaterView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final waterFlowState = ref.watch(feedWaterProvider);
    final waterFlowNotifier = ref.read(feedWaterProvider.notifier);

    if (waterFlowState.items.isEmpty && waterFlowState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (waterFlowState.error != null && waterFlowState.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('加载失败: ${waterFlowState.error}'),
            ElevatedButton(
              onPressed: () => waterFlowNotifier.loadMoreData(),
              child: const Text('重试'),
            ),
          ],
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
            waterFlowState.hasMore &&
            !waterFlowState.isLoading) {
          waterFlowNotifier.loadMoreData();
        }
        return false;
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: MasonryGridView.count(
          crossAxisCount: 2, // 两列瀑布流
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          itemCount: waterFlowState.items.length + (waterFlowState.isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == waterFlowState.items.length) {
              return const Center(child: CircularProgressIndicator()); // 加载更多指示器
            }
            final item = waterFlowState.items[index];
            return FeedWaterCard(data: item);
          },
        ),
      ),
    );
  }
}
