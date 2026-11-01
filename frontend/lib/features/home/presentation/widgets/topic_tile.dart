import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/quiz_topic.dart';

class TopicTile extends StatelessWidget {
  const TopicTile({super.key, required this.topic, required this.selected, required this.onTap});
  final QuizTopic topic;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: Theme.of(context).colorScheme.surface,
    borderRadius: BorderRadius.circular(14),
    child: InkWell(
      onTap: onTap, borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: Theme.of(context).dividerColor, width: .7), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .025), blurRadius: 7, offset: const Offset(0, 2))]),
        child: Row(children: [
          Container(width: 48, height: 48, decoration: BoxDecoration(color: const Color(0xFFE5E4FF), borderRadius: BorderRadius.circular(13)), child: Icon(topic.icon, color: const Color(0xFF4033D8), size: 25)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [Flexible(child: Text(topic.title, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18))), const SizedBox(width: 8), Flexible(child: Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3), decoration: BoxDecoration(color: topic.badgeColor, borderRadius: BorderRadius.circular(20)), child: Text(topic.badge, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, color: Color(0xFF45465A), fontWeight: FontWeight.w500))))]),
            const SizedBox(height: 3), Text(topic.subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 13.5)),
          ])),
          const SizedBox(width: 8),
          Container(width: 28, height: 28, decoration: BoxDecoration(color: selected ? AppColors.primary : const Color(0xFFECEEFF), shape: BoxShape.circle), child: selected ? const Icon(Icons.check_rounded, color: Colors.white, size: 20) : null),
        ]),
      ),
    ),
  );
}
