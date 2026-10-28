import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class StreakBadge extends StatelessWidget {
  const StreakBadge({super.key});
  @override
  Widget build(BuildContext context) => Center(child: Container(
    margin: const EdgeInsets.only(top: 8, bottom: 16), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
    decoration: BoxDecoration(color: AppColors.palePurple.withValues(alpha: .8), borderRadius: BorderRadius.circular(30)),
    child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.local_fire_department_rounded, color: Color(0xFFFFA53D), size: 16), SizedBox(width: 4), Text('5 Dias Seguidos', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.text))]),
  ));
}
