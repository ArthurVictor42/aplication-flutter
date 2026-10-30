import 'package:flutter/material.dart';
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
          padding: const EdgeInsets.all(20),
          children: [
            Text('GERAL', style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 12),
            Card(child: SwitchListTile(
              secondary: const CircleAvatar(child: Icon(Icons.dark_mode_outlined)),
              title: const Text('Tema escuro'),
              subtitle: Text(controller.isDark ? 'Ativado (Escuro)' : 'Desativado (Claro)'),
              value: controller.isDark,
              onChanged: controller.setDarkMode,
            )),
            const SizedBox(height: 18),
            Text('PREFERÊNCIAS DE IDIOMA', style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 12),
            const Card(child: ListTile(
              leading: CircleAvatar(child: Icon(Icons.language)),
              title: Text('Idioma do Quiz'),
              subtitle: Text('Português (Brasil) — interface'),
              trailing: Icon(Icons.check_circle, color: Colors.green),
            )),
            const SizedBox(height: 18),
            Text('SOBRE', style: Theme.of(context).textTheme.labelSmall),
            const Card(child: ListTile(
              leading: CircleAvatar(child: Icon(Icons.info_outline)),
              title: Text('Quiz Motion'),
              subtitle: Text('Aplicativo de perguntas e conhecimentos.'),
            )),
          ],
        ),
      ),
    );
  }
}
