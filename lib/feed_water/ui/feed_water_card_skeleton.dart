import 'package:flutter/material.dart';

class FeedWaterCardSkeleton extends StatelessWidget {
  final double aspectRatio;
  static const Color _skeletonColor = Color(0xFFe0e0e0);

  const FeedWaterCardSkeleton({
    super.key,
    required this.aspectRatio,
  });

  Widget _buildSkeletonBox(
      {double width = double.infinity,
      double height = 16,
      BorderRadius? borderRadius}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: _skeletonColor,
        borderRadius: borderRadius ?? BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildSkeletonCircle({double size = 18}) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: _skeletonColor,
        shape: BoxShape.circle,
      ),
    );
  }

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
          // 图片骨架
          AspectRatio(
              aspectRatio: aspectRatio,
              child: Container(color: _skeletonColor)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 标题骨架
                _buildSkeletonBox(
                    height: 20, borderRadius: BorderRadius.circular(6)),
                const SizedBox(height: 8),
                // 作者和点赞骨架
                Row(
                  children: [
                    _buildSkeletonCircle(size: 18),
                    const SizedBox(width: 4),
                    _buildSkeletonBox(width: 100, height: 16),
                    const Spacer(),
                    _buildSkeletonBox(width: 40, height: 16),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}