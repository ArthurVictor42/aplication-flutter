import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_theme.dart';
import 'section_label.dart';

/// Rótulo "Criar pergunta" + contador + card com o campo de texto.
class QuestionField extends StatelessWidget {
  const QuestionField({super.key, required this.controller});

  final TextEditingController controller;

  static const int maxLength = 180;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionLabel(
          icon: Icons.edit_note_rounded,
          title: 'Criar pergunta',
          // Redesenha só o contador quando o texto do controller muda.
          trailing: ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, _) => Text(
              '${value.text.length} / $maxLength',
              style: const TextStyle(fontSize: 11, color: AppColors.muted),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: controller,
                minLines: 3,
                maxLines: 5,
                // Limita a 180 caracteres sem mostrar o contador padrão do Flutter.
                inputFormatters: [LengthLimitingTextInputFormatter(maxLength)],
                style: const TextStyle(fontSize: 16, color: AppColors.text),
                decoration: const InputDecoration(
                  hintText: 'Digite o enunciado da pergunta com clareza...',
                  hintStyle: TextStyle(fontSize: 16, color: AppColors.hint),
                  border: InputBorder.none, // tira a borda padrão do TextField
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const SizedBox(height: 14),
              const Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    size: 15,
                    color: AppColors.amber,
                  ),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Mantenha frases curtas e objetivas',
                      style: TextStyle(fontSize: 11, color: AppColors.muted),
                    ),
                  ),
                  Icon(Icons.format_italic, size: 15, color: AppColors.muted),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
