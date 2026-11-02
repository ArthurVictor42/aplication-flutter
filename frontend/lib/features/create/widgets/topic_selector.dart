import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class TopicOption {
  const TopicOption({
    required this.code,
    required this.title,
    required this.subtitle,
  });

  final String code;
  final String title;
  final String subtitle;
}

class TopicSelector extends StatelessWidget {
  const TopicSelector({
    super.key,
    required this.topics,
    required this.selectedIndex,
    required this.onChanged,
  });

  final List<TopicOption> topics;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.palePurple.withValues(alpha: .5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: selectedIndex,
          isExpanded: true,
          itemHeight: 68,
          borderRadius: BorderRadius.circular(14),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.muted,
          ),
          selectedItemBuilder: (context) =>
              topics.map((t) => _TopicRow(topic: t)).toList(),

          items: List.generate(
            topics.length,
            (i) => DropdownMenuItem(
              value: i,
              child: _TopicRow(topic: topics[i]),
            ),
          ),
          onChanged: (i) {
            if (i != null) onChanged(i);
          },
        ),
      ),
    );
  }
}

/// Linha: [sigla] [título + subtítulo]
class _TopicRow extends StatelessWidget {
  const _TopicRow({required this.topic});

  final TopicOption topic;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.palePurple,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            topic.code,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                topic.title,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Text(
                topic.subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 11.5, color: AppColors.muted),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
