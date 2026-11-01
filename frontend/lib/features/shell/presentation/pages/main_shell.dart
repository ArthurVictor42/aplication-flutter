import 'package:flutter/material.dart';

import '../../../home/presentation/pages/home_page.dart';
import '../../../home/presentation/widgets/home_bottom_nav.dart';
import '../../../create/presentation/pages/create_question_page.dart';
import '../../../settings/presentation/pages/settings_page.dart';
import '../../../challenges/presentation/pages/challenges_page.dart';
import '../../../quiz/presentation/pages/active_quiz_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  void _startQuiz(QuizLaunch launch) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ActiveQuizPage(
        launch: launch,
        onExit: () => Navigator.of(context).pop(),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(onStartQuiz: _startQuiz),
      CreateQuestionPage(onBack: () => setState(() => _index = 0)),
      const ChallengesPage(),
      const SettingsPage(),
    ];
    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: HomeBottomNav(
        selectedIndex: _index,
        onSelected: (i) => setState(() => _index = i),
      ),
    );
  }
}
