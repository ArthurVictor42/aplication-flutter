import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/theme_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ThemeController.instance;
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações'), centerTitle: false),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) => ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.palePurple,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(
                    Icons.tune_rounded,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Personalize sua experiência',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'Ajuste a aparência do aplicativo',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Text(
              'GERAL',
              style: Theme.of(context).textTheme.labelSmall
                  ?.copyWith(letterSpacing: .7),
            ),
            const SizedBox(height: 10),
            Card(
              child: SwitchListTile(
                secondary: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.palePurple,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.dark_mode_outlined,
                    color: AppColors.primary,
                  ),
                ),
                title: const Text('Tema Escuro'),
                subtitle: Text(
                  controller.isDark ? 'Ativado (Escuro)' : 'Desativado (Claro)',
                ),
                value: controller.isDark,
                onChanged: controller.setDarkMode,
              ),
            ),
            const SizedBox(height: 22),
            Text(
              'PREFERÊNCIAS DE IDIOMA',
              style: Theme.of(context).textTheme.labelSmall
                  ?.copyWith(letterSpacing: .7),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                leading: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.palePurple,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.language_rounded,
                    color: AppColors.primary,
                  ),
                ),
                title: const Text('Idioma da interface'),
                subtitle: const Text('Português (Brasil)'),
                trailing: const Icon(
                  Icons.check_circle,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 22),
            Text(
              'SOBRE',
              style: Theme.of(context).textTheme.labelSmall
                  ?.copyWith(letterSpacing: .7),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                leading: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.palePurple,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.primary,
                  ),
                ),
                title: const Text('Quiz Motion'),
                subtitle: const Text(
                  'Aplicativo de perguntas e conhecimentos.',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
