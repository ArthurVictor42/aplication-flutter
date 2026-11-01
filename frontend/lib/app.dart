import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/shell/presentation/pages/main_shell.dart';

class QuizMotionApp extends StatelessWidget {
  const QuizMotionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ThemeController.instance,
      builder: (context, _) => MaterialApp(
        title: 'Quiz Motion',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeController.instance.themeMode,
        home: const MainShell(),
      ),
    );
  }
}
