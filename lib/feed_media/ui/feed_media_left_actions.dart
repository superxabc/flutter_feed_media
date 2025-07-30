import 'package:flutter/material.dart';

class FeedMediaLeftActions extends StatefulWidget {
  final VoidCallback? onAvatarTap;
  final VoidCallback? onFollowTap;
  final VoidCallback? onLikeTap;
  final VoidCallback? onCommentTap;
  final VoidCallback? onShareTap;
  final bool initialIsLiked;
  final bool initialIsFollowing;
  final int initialLikeCount;

  const FeedMediaLeftActions({
    super.key,
    this.onAvatarTap,
    this.onFollowTap,
    this.onLikeTap,
    this.onCommentTap,
    this.onShareTap,
    this.initialIsLiked = false,
    this.initialIsFollowing = false,
    this.initialLikeCount = 1234,
  });

  @override
  State<FeedMediaLeftActions> createState() => _FeedMediaLeftActionsState();
}

class _FeedMediaLeftActionsState extends State<FeedMediaLeftActions>
    with SingleTickerProviderStateMixin {
  late bool _isLiked;
  late bool _isFollowing;
  late int _likeCount;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.initialIsLiked;
    _isFollowing = widget.initialIsFollowing;
    _likeCount = widget.initialLikeCount;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // 公共方法：供外部触发点赞
  void triggerLike() {
    _onLikeTap();
  }

  void _onAvatarTap() {
    widget.onAvatarTap?.call();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Navigate to user profile'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _onFollowTap() {
    setState(() {
      _isFollowing = !_isFollowing;
    });
    widget.onFollowTap?.call();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isFollowing ? 'Following user' : 'Unfollowed user'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _onLikeTap() {
    setState(() {
      _isLiked = !_isLiked;
      _likeCount += _isLiked ? 1 : -1;
    });

    if (_isLiked) {
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
    }

    widget.onLikeTap?.call();
  }

  void _onCommentTap() {
    widget.onCommentTap?.call();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Open comments'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _onShareTap() {
    widget.onShareTap?.call();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share content'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // 用户头像和关注按钮
        _buildUserSection(),
        const SizedBox(height: 20),
        // 社交操作按钮
        _buildSocialActions(),
      ],
    );
  }

  Widget _buildUserSection() {
    return Column(
      children: [
        GestureDetector(
          onTap: _onAvatarTap,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey[300],
              child: const Icon(Icons.person, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: _onFollowTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _isFollowing ? Colors.grey.withOpacity(0.8) : Colors.red,
              borderRadius: BorderRadius.circular(10),
              border: _isFollowing
                  ? Border.all(color: Colors.white, width: 1)
                  : null,
            ),
            child: Text(
              _isFollowing ? '✓ Following' : '+ Follow',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialActions() {
    return Column(
      children: [
        // 点赞按钮
        _buildActionButton(
          onTap: _onLikeTap,
          icon: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _isLiked ? _scaleAnimation.value : 1.0,
                child: Icon(
                  _isLiked ? Icons.favorite : Icons.favorite_border,
                  color: _isLiked ? Colors.red : Colors.white,
                  size: 35,
                ),
              );
            },
          ),
          count: _formatCount(_likeCount),
        ),
        const SizedBox(height: 15),
        // 评论按钮
        _buildActionButton(
          onTap: _onCommentTap,
          icon: const Icon(Icons.comment, color: Colors.white, size: 35),
          count: '567',
        ),
        const SizedBox(height: 15),
        // 分享按钮
        _buildActionButton(
          onTap: _onShareTap,
          icon: const Icon(Icons.share, color: Colors.white, size: 35),
          count: '89',
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required VoidCallback onTap,
    required Widget icon,
    required String count,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withOpacity(0.3),
            ),
            child: icon,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          count,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            shadows: [
              Shadow(
                offset: Offset(1, 1),
                blurRadius: 2,
                color: Colors.black54,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}
