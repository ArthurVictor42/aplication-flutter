import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// Cabeçalho: botão voltar, "EDITOR DE CONTEÚDO" + título e chip "Modo Rápido".
class CreateHeader extends StatelessWidget {
  const CreateHeader({super.key, this.onBack, this.onQuickMode});

  final VoidCallback? onBack; // null = botão sem ação
  final VoidCallback? onQuickMode; // null = chip só visual

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Material dá a cor de fundo; InkWell dá o efeito de toque por cima dela.
        Material(
          color: AppColors.palePurple,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: onBack,
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 40,
              height: 40,
              child: Icon(
                Icons.arrow_back,
                size: 20,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Expanded ocupa o espaço que sobra e empurra o chip para a direita.
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'EDITOR DE CONTEÚDO',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: .8,
                  color: AppColors.primary,
                ),
              ),
              Text(
                'Criar Pergunta',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -.3,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
        Material(
          color: AppColors.palePurple,
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            onTap: onQuickMode,
            borderRadius: BorderRadius.circular(20),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Row(
                mainAxisSize:
                    MainAxisSize.min, // chip só do tamanho do conteúdo
                children: [
                  Icon(
                    Icons.arrow_back_ios_new,
                    size: 11,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Modo Rápido',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
