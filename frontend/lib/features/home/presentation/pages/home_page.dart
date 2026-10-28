import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../data/quiz_topics.dart';
import '../widgets/challenge_card.dart';
import '../widgets/home_header.dart';
import '../widgets/score_summary.dart';
import '../widgets/streak_badge.dart';
import '../widgets/topic_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedTopic = 0;
  int _questionCount = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HomeHeader(),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth > 600;
                final horizontal = wide ? 32.0 : 20.0;
                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(horizontal, 0, horizontal, 22),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 650),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const StreakBadge(),
                          SizedBox(height: wide ? 4 : 0),
                          const ChallengeCard(),
                          const SizedBox(height: 26),
                          Row(
                            children: [
                              const Icon(
                                Icons.category_outlined,
                                color: AppColors.primary,
                                size: 19,
                              ),
                              const SizedBox(width: 5),
                              const Expanded(
                                child: Text(
                                  'Escolha o Tema',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.text,
                                    letterSpacing: -.3,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () => setState(
                                  () => _selectedTopic =
                                      (_selectedTopic + 1) % quizTopics.length,
                                ),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                ),
                                child: const Text(
                                  'Ver todos (8)',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ...List.generate(
                            quizTopics.length,
                            (index) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: TopicTile(
                                topic: quizTopics[index],
                                selected: _selectedTopic == index,
                                onTap: () =>
                                    setState(() => _selectedTopic = index),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          ScoreSummary(
                            questionCount: _questionCount,
                            onQuestionCountChanged: (count) =>
                                setState(() => _questionCount = count),
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            height: 56,
                            child: ElevatedButton.icon(
                              onPressed: () =>
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Iniciando quiz de ${quizTopics[_selectedTopic].title} com $_questionCount perguntas',
                                      ),
                                    ),
                                  ),
                              icon: const Icon(
                                Icons.play_arrow_rounded,
                                size: 25,
                              ),
                              label: const Text(
                                'JOGAR',
                                style: TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: .3,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                elevation: 3,
                                shadowColor: AppColors.primary.withValues(
                                  alpha: .22,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.timer_outlined,
                                size: 14,
                                color: Color(0xFF66677A),
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Tempo estimado: ~2 minutos',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF66677A),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 28),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
