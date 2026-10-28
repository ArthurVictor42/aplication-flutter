import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class ChallengeCard extends StatelessWidget {
  const ChallengeCard({super.key});
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity, height: 262,
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(13),
      gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF5143ED), Color(0xFF3420CF)]),
      boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: .16), blurRadius: 10, offset: const Offset(0, 5))],
    ),
    child: Column(children: [
      Align(alignment: Alignment.centerLeft, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: const Color(0xFF3122B8), borderRadius: BorderRadius.circular(20)), child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.circle, color: AppColors.green, size: 8), SizedBox(width: 6), Text('GIF • EM MOVIMENTO', style: TextStyle(color: Colors.white, fontSize: 10, letterSpacing: .3))]))),
      Expanded(child: Stack(alignment: Alignment.center, children: [
        Container(width: 120, height: 120, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white.withValues(alpha: .28), width: 7), color: Colors.white.withValues(alpha: .10))),
        ClipOval(child: Image.asset('assets/images/hero_quiz.png', width: 108, height: 108, fit: BoxFit.cover)),
        Positioned(right: 18, top: 0, child: Transform.rotate(angle: .15, child: Container(width: 35, height: 35, decoration: BoxDecoration(color: AppColors.green, borderRadius: BorderRadius.circular(11)), child: const Icon(Icons.help_outline_rounded, color: Color(0xFF12664E), size: 23)))),
      ])),
      const SizedBox(height: 8),
      const Text('Pronto para o Desafio?', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.w800, letterSpacing: -.7)),
      const SizedBox(height: 3),
      Text('Responda rápido, acumule pontos e suba no ranking!', textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withValues(alpha: .76), fontSize: 14, height: 1.35)),
    ]),
  );
}
