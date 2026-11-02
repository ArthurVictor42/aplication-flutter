import 'package:flutter/material.dart';

import '../../../../core/network/quiz_api_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/quiz_topics.dart';
import '../../domain/quiz_topic.dart';
import '../widgets/home_header.dart';
import '../widgets/topic_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.onStartQuiz});
  final ValueChanged<QuizLaunch> onStartQuiz;

  @override
  State<HomePage> createState() => _HomePageState();
}

class QuizLaunch {
  const QuizLaunch({
    required this.theme,
    required this.limit,
    required this.questions,
  });
  final String? theme;
  final int limit;
  final List<Map<String, dynamic>> questions;
}

class _HomePageState extends State<HomePage> {
  int _selectedTopic = 0;
  int _questionCount = 10;
  bool _loadingThemes = false;
  bool _starting = false;

  List<QuizTopic> get _topics => quizTopics;

  Future<void> _refreshThemes() async {
    setState(() => _loadingThemes = true);
    try {
      await QuizApiService.listarTemas();
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Temas atualizados.')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não foi possível atualizar os temas: $e')),
      );
    } finally {
      if (mounted) setState(() => _loadingThemes = false);
    }
  }

  Future<void> _startQuiz() async {
    if (_starting) return;
    final selectedTheme = _topics[_selectedTopic].title;
    setState(() => _starting = true);
    try {
      final questions = await QuizApiService.buscarPerguntas(
        tema: selectedTheme,
        limite: _questionCount,
      );
      if (!mounted) return;
      if (questions.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Ainda não existem perguntas cadastradas para $selectedTheme.',
            ),
          ),
        );
        return;
      }
      widget.onStartQuiz(
        QuizLaunch(
          theme: selectedTheme,
          limit: _questionCount,
          questions: questions,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não foi possível iniciar o quiz: $e')),
      );
    } finally {
      if (mounted) setState(() => _starting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Column(
        children: [
          const HomeHeader(),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final horizontal = constraints.maxWidth > 600 ? 32.0 : 20.0;
                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(horizontal, 8, horizontal, 24),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 650),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _WelcomeCard(dark: dark),
                          const SizedBox(height: 25),
                          Row(
                            children: [
                              const Icon(
                                Icons.category_outlined,
                                color: AppColors.primary,
                                size: 19,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'Escolha o Tema',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                              if (_loadingThemes)
                                const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              else
                                TextButton(
                                  onPressed: _refreshThemes,
                                  child: const Text('Atualizar'),
                                ),
                            ],
                          ),
                          const SizedBox(height: 9),
                          ...List.generate(
                            _topics.length,
                            (index) => Padding(
                              padding: const EdgeInsets.only(bottom: 9),
                              child: TopicTile(
                                topic: _topics[index],
                                selected: _selectedTopic == index,
                                onTap: () =>
                                    setState(() => _selectedTopic = index),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Text(
                                'Quantidade de perguntas',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const Spacer(),
                              Text(
                                '$_questionCount perguntas',
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: [5, 10, 15, 20]
                                .map(
                                  (count) => ChoiceChip(
                                    label: Text('$count'),
                                    selected: _questionCount == count,
                                    onSelected: (_) =>
                                        setState(() => _questionCount = count),
                                  ),
                                )
                                .toList(),
                          ),
                          const SizedBox(height: 26),
                          SizedBox(
                            height: 56,
                            child: ElevatedButton.icon(
                              onPressed: _starting ? null : _startQuiz,
                              icon: _starting
                                  ? const SizedBox(
                                      width: 19,
                                      height: 19,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.play_arrow_rounded,
                                      size: 25,
                                    ),
                              label: Text(
                                _starting ? 'CARREGANDO...' : 'JOGAR',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Tempo estimado: ~${(_questionCount * 12 / 60).ceil()} minutos',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
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

class _WelcomeCard extends StatelessWidget {
  const _WelcomeCard({required this.dark});
  final bool dark;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(18),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: dark
            ? const [Color(0xFF27205F), Color(0xFF171B35)]
            : const [Color(0xFF5143E9), Color(0xFF3825D9)],
      ),
      boxShadow: [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: .18),
          blurRadius: 16,
          offset: const Offset(0, 7),
        ),
      ],
    ),
    child: Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: .18),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.circle, color: Color(0xFF5DE7B1), size: 9),
                SizedBox(width: 6),
                Text(
                  'QUIZ MOTION',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 116,
          child: Image.asset(
            'assets/images/hero_quiz.png',
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 9),
        const Text(
          'Pronto para o Desafio?',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 23,
            fontWeight: FontWeight.w800,
            letterSpacing: -.6,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Responda às perguntas, teste seus conhecimentos e evolua!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withValues(alpha: .82),
            fontSize: 14,
            height: 1.35,
          ),
        ),
      ],
    ),
  );
}
