import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// Caixa informativa "Garantia de Qualidade" (só visual).
class QualityNotice extends StatelessWidget {
  const QualityNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF24243B) : AppColors.palePurple.withValues(alpha: .5),
        borderRadius: BorderRadius.circular(14),
      ),
      // Sem const aqui: o CircleAvatar usa withValues, que não é constante.
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // ícone alinhado ao topo
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.green.withValues(alpha: .25),
            child: const Icon(
              Icons.verified_outlined,
              size: 18,
              color: AppColors.greenDark,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Garantia de Qualidade',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Perguntas com pelo menos 4 opções e uma resposta marcada '
                  'são publicadas instantaneamente no lobby da comunidade.',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.35, // espaçamento entre linhas
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
