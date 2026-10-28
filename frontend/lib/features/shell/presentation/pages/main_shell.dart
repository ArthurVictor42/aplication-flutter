import 'package:flutter/material.dart';

import '../../../home/presentation/pages/home_page.dart';
import '../../../home/presentation/widgets/home_bottom_nav.dart';
import '../../../create/presentation/pages/create_question_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          HomePage(),
          CreateQuestionPage(onBack: () => setState(() => _index = 0)),
          Placeholder(),
          Placeholder(),
        ],
      ),
      bottomNavigationBar: HomeBottomNav(
        selectedIndex: _index,
        onSelected: (i) => setState(() => _index = i),
      ),
    );
  }
}
