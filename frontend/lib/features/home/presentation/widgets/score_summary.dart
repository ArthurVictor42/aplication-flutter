import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class ScoreSummary extends StatelessWidget {
  const ScoreSummary({super.key, required this.questionCount, required this.onQuestionCountChanged});
  final int questionCount;
  final ValueChanged<int> onQuestionCountChanged;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
    decoration: BoxDecoration(color: const Color(0xFFE9EBFF), borderRadius: BorderRadius.circular(13)),
    child: Row(children: [
      Container(width: 40, height: 40, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.emoji_events_outlined, color: Color(0xFF087D57), size: 24)),
      const SizedBox(width: 9),
      const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Melhor Pontuação', style: TextStyle(fontSize: 11, color: Color(0xFF55596D))), SizedBox(height: 3), Text('2.480 pts', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800, color: Color(0xFF1E2438), height: 1.05))])),
      Container(width: 1, height: 34, color: const Color(0xFFD9DCF6)),
      const SizedBox(width: 12),
      Expanded(child: InkWell(onTap: () => onQuestionCountChanged(questionCount == 10 ? 20 : 10), borderRadius: BorderRadius.circular(8), child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [const Text('Modo', style: TextStyle(fontSize: 11, color: Color(0xFF55596D))), const SizedBox(height: 5), Text('$questionCount Perguntas', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.primary), textAlign: TextAlign.end)]))),
    ]),
  );
}
