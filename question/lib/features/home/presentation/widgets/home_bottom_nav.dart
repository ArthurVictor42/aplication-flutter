import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class HomeBottomNav extends StatelessWidget {
  const HomeBottomNav({super.key, required this.selectedIndex, required this.onSelected});
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  static const _items = [
    (Icons.explore_outlined, 'Lobby'), (Icons.add_circle_outline_rounded, 'Criar'), (Icons.local_fire_department_outlined, 'Desafios'), (Icons.settings_outlined, 'Ajustes'),
  ];
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(8, 8, 8, 5),
    decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .06), blurRadius: 12, offset: const Offset(0, -3))]),
    child: SafeArea(top: false, child: Row(children: List.generate(_items.length, (i) {
      final item = _items[i]; final active = selectedIndex == i;
      return Expanded(child: InkWell(onTap: () => onSelected(i), borderRadius: BorderRadius.circular(12), child: Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(item.$1, color: active ? AppColors.primary : const Color(0xFF45475A), size: 23), const SizedBox(height: 3), Text(item.$2, style: TextStyle(fontSize: 11, color: active ? AppColors.primary : const Color(0xFF45475A), fontWeight: active ? FontWeight.w600 : FontWeight.w400))]))));
    }))),
  );
}
