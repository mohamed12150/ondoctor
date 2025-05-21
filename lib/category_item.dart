import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final String title;
  final Widget? iconWidget;
  final VoidCallback? onTap;

  const CategoryItem({
    super.key,
    required this.title,
    this.iconWidget,
    this.onTap, required String routeName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 247, 246, 248),
                shape: BoxShape.circle,
              ),
              child: iconWidget ??
                  const Icon(
                    Icons.help_outline,
                    size: 30,
                    color: Color.fromARGB(255, 122, 4, 240),
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
