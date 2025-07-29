import 'package:flutter/material.dart';

class FeedMediaLeftActions extends StatelessWidget {
  const FeedMediaLeftActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // UserHeader (Placeholder)
        Column(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey[300],
              child: const Icon(Icons.person, color: Colors.white),
            ),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                '+ Follow',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // SocialActions (Placeholder)
        Column(
          children: [
            IconButton(
              icon: const Icon(Icons.favorite_border, color: Colors.white, size: 35),
              onPressed: () {},
            ),
            const SizedBox(height: 10),
            IconButton(
              icon: const Icon(Icons.comment, color: Colors.white, size: 35),
              onPressed: () {},
            ),
            const SizedBox(height: 10),
            IconButton(
              icon: const Icon(Icons.share, color: Colors.white, size: 35),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}
