import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// Dados que o seletor mostra. Separar isso do QuizTopic deixa o widget
/// independente do resto do projeto.
class TopicOption {
  const TopicOption({
    required this.code,
    required this.title,
    required this.subtitle,
  });

  final String code; // sigla: "EN"
  final String title; // "Inglês"
  final String subtitle; // "Vocabulário, Expressões & Gramática"
}

/// Card com o tema escolhido. Ao tocar, abre a lista de temas.
class TopicSelector extends StatelessWidget {
  const TopicSelector({
    super.key,
    required this.topics,
    required this.selectedIndex,
    required this.onChanged,
  });

  final List<TopicOption> topics;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.palePurple.withValues(alpha: .5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      // DropdownButtonHideUnderline remove a linha padrão do dropdown.
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: selectedIndex,
          isExpanded: true,
          itemHeight: 68, // o padrão (48) cortaria o subtítulo
          borderRadius: BorderRadius.circular(14),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.muted,
          ),
          // Como o item aparece com o dropdown FECHADO.
          selectedItemBuilder: (context) =>
              topics.map((t) => _TopicRow(topic: t)).toList(),
          // Como cada item aparece na lista ABERTA.
          items: List.generate(
            topics.length,
            (i) => DropdownMenuItem(
              value: i,
              child: _TopicRow(topic: topics[i]),
            ),
          ),
          onChanged: (i) {
            if (i != null) onChanged(i); // i pode ser null, então checamos
          },
        ),
      ),
    );
  }
}

/// Linha: [sigla] [título + subtítulo]
class _TopicRow extends StatelessWidget {
  const _TopicRow({required this.topic});

  final TopicOption topic;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.palePurple,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            topic.code,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                topic.title,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Text(
                topic.subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis, // "..." se não couber
                style: const TextStyle(fontSize: 11.5, color: AppColors.muted),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
