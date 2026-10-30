import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(20, 12, 20, 14),
    decoration: BoxDecoration(
      color: Theme.of(context).scaffoldBackgroundColor,
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .035), blurRadius: 12, offset: const Offset(0, 3))],
    ),
    child: Row(children: [
      Container(width: 34, height: 34, decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(9)),
        child: const Icon(Icons.question_mark_rounded, color: Colors.white, size: 23)),
      const SizedBox(width: 9),
      const Expanded(child: Text('Quiz Motion', style: TextStyle(color: AppColors.primary, fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: -.6))),
      IconButton(onPressed: () {}, icon: Icon(Icons.menu_rounded, color: Theme.of(context).colorScheme.onSurface, size: 24), tooltip: 'Menu'),
      const SizedBox(width: 4),
      Container(width: 34, height: 34, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
        child: IconButton(padding: EdgeInsets.zero, onPressed: () {}, icon: const Icon(Icons.person_outline_rounded, color: Colors.white, size: 20), tooltip: 'Perfil')),
    ]),
  );
}
