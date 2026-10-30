import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class ScoreSummary extends StatelessWidget {
  const ScoreSummary({super.key, required this.questionCount, required this.onQuestionCountChanged});
  final int questionCount;
  final ValueChanged<int> onQuestionCountChanged;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF202238) : const Color(0xFFE9EBFF),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(children: [
        Container(width: 40, height: 40, decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(10)),
          child: const Icon(Icons.emoji_events_outlined, color: Color(0xFF087D57), size: 24)),
        const SizedBox(width: 9),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Melhor Pontuação', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11)),
          const SizedBox(height: 3),
          Text('— pts', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 21)),
        ])),
        Container(width: 1, height: 34, color: Theme.of(context).dividerColor),
        const SizedBox(width: 12),
        Expanded(child: InkWell(
          onTap: () => onQuestionCountChanged(questionCount == 10 ? 20 : 10),
          borderRadius: BorderRadius.circular(8),
          child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('Modo', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11)),
            const SizedBox(height: 5),
            Text('$questionCount Perguntas', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.primary), textAlign: TextAlign.end),
          ]),
        )),
      ]),
    );
  }
}
