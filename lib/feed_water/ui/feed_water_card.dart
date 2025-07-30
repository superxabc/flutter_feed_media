import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/feed_water_model.dart';
import 'feed_water_card_skeleton.dart';

class FeedWaterCard extends StatelessWidget {
  final FeedWaterItemModel data;
  final VoidCallback? onImageTap;
  final VoidCallback? onAuthorTap;
  final VoidCallback? onLikeTap;

  const FeedWaterCard({
    super.key,
    required this.data,
    this.onImageTap,
    this.onAuthorTap,
    this.onLikeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: Colors.white,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 图片区域
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onImageTap,
            child: AspectRatio(
              aspectRatio: data.aspectRatio,
              child: CachedNetworkImage(
                imageUrl: data.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                placeholder: (context, url) => FeedWaterCardSkeleton(aspectRatio: data.aspectRatio),
                errorWidget: (context, url, error) {
                  return Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.grey,
                        size: 40,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // 内容区域
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 标题
                Text(
                  data.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 4),

                // 标签
                if (data.tags.isNotEmpty)
                  Wrap(
                    spacing: 4.0,
                    runSpacing: 4.0,
                    children: data.tags
                        .map((tag) => Chip(
                              label: Text(tag),
                              labelStyle: const TextStyle(fontSize: 10),
                              padding: EdgeInsets.zero,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ))
                        .toList(),
                  ),

                const SizedBox(height: 4),

                // 作者和点赞
                // 假设 'normal' 类型有作者和点赞
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Row(
                    children: [
                      // 作者头像和名字
                      if (data.avatarUrl != null)
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: onAuthorTap,
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 9, // 头像尺寸调整为和点赞图标一致
                                backgroundImage:
                                    NetworkImage(data.avatarUrl!),
                              ),
                              const SizedBox(width: 2),
                              if (data.author != null)
                                Text(
                                  data.author!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                        ),

                      const Spacer(),

                      // 点赞按钮和数量
                      if (data.likes != null)
                        Row(
                          children: [
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: onLikeTap,
                              child: Icon(
                                data.isLiked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color:
                                    data.isLiked ? Colors.red : Colors.grey,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              data.likes.toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}