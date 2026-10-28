import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// Título de seção: [ícone] Título ........ [trailing]
/// Usado em "Tema / Matéria", "Criar pergunta" e "Alternativas".
class SectionLabel extends StatelessWidget {
  const SectionLabel({
    super.key,
    required this.icon,
    required this.title,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final Widget? trailing; // widget opcional na ponta direita

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

/// Bolinha verde + "Ativo".
class ActiveStatus extends StatelessWidget {
  const ActiveStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(radius: 3.5, backgroundColor: AppColors.greenDark),
        SizedBox(width: 5),
        Text(
          'Ativo',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.greenDark,
          ),
        ),
      ],
    );
  }
}

/// Pílula de texto pequeno, como "Marque a correta".
class HintPill extends StatelessWidget {
  const HintPill(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.palePurple,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: AppColors.muted,
        ),
      ),
    );
  }
}
