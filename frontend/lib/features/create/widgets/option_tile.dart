import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// Uma alternativa: [letra] [campo de texto] [marcador de correta].
class OptionTile extends StatelessWidget {
  const OptionTile({
    super.key,
    required this.letter,
    required this.controller,
    required this.selected,
    required this.onSelected,
  });

  final String letter; // "A", "B", "C" ou "D"
  final TextEditingController controller;
  final bool selected; // true = esta é a alternativa correta
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Caixa da letra: escura se for a correta, clara nas demais.
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? AppColors.primary : (Theme.of(context).brightness == Brightness.dark ? const Color(0xFF303247) : AppColors.palePurple),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              letter,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: selected ? Colors.white : AppColors.muted,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: TextField(
              controller: controller,
              style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurface),
              decoration: const InputDecoration(
                hintText: 'Digite a alternativa...',
                hintStyle: TextStyle(fontSize: 14, color: AppColors.hint),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
          // GestureDetector detecta o toque; o Padding aumenta a área clicável.
          GestureDetector(
            onTap: onSelected,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Icon(
                selected ? Icons.check_circle : Icons.radio_button_unchecked,
                size: 26,
                color: selected ? AppColors.primary : AppColors.hint,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
