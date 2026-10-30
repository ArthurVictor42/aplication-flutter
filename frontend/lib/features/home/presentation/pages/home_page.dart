import 'package:flutter/material.dart';

import '../../../../core/network/quiz_api_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/quiz_topics.dart';
import '../../domain/quiz_topic.dart';
import '../widgets/challenge_card.dart';
import '../widgets/home_header.dart';
import '../widgets/score_summary.dart';
import '../widgets/streak_badge.dart';
import '../widgets/topic_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.onStartQuiz});
  final ValueChanged<QuizLaunch> onStartQuiz;

  @override
  State<HomePage> createState() => _HomePageState();
}

class QuizLaunch {
  const QuizLaunch({required this.theme, required this.limit, required this.questions});
  final String? theme;
  final int limit;
  final List<Map<String, dynamic>> questions;
}

class _HomePageState extends State<HomePage> {
  int _selectedTopic = 0;
  int _questionCount = 10;
  List<String> _availableThemes = [];
  bool _loadingThemes = false;

  @override
  void initState() {
    super.initState();
    _loadThemes();
  }

  Future<void> _loadThemes() async {
    setState(() => _loadingThemes = true);
    try {
      final themes = await QuizApiService.listarTemas();
      if (!mounted) return;
      setState(() {
        _availableThemes = themes;
        _selectedTopic = 0;
      });
    } catch (_) {
      // A home continua utilizável mesmo se a API estiver indisponível.
    } finally {
      if (mounted) setState(() => _loadingThemes = false);
    }
  }

  List<QuizTopic> get _topics {
    if (_availableThemes.isEmpty) return quizTopics;
    return _availableThemes.map((name) {
      QuizTopic? existing;
      for (final topic in quizTopics) {
        if (topic.title.toLowerCase() == name.toLowerCase()) { existing = topic; break; }
      }
      return existing ?? QuizTopic(
        title: name,
        subtitle: 'Perguntas cadastradas na plataforma',
        badge: 'Tema',
        icon: Icons.auto_awesome_outlined,
        badgeColor: const Color(0xFFE8E9FF),
      );
    }).toList();
  }

  Future<void> _startQuiz() async {
    final topics = _topics;
    final selectedTheme = topics.isEmpty ? null : topics[_selectedTopic.clamp(0, topics.length - 1)].title;
    try {
      final questions = await QuizApiService.buscarPerguntas(
        tema: selectedTheme,
        limite: _questionCount,
      );
      if (!mounted) return;
      if (questions.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(selectedTheme == null
              ? 'Ainda não existem perguntas cadastradas.'
              : 'Ainda não existem perguntas cadastradas para $selectedTheme.')),
        );
        return;
      }
      widget.onStartQuiz(QuizLaunch(theme: selectedTheme, limit: _questionCount, questions: questions));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não foi possível iniciar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final topics = _topics;
    return Scaffold(
      body: Column(children: [
        const HomeHeader(),
        Expanded(child: LayoutBuilder(builder: (context, constraints) {
          final wide = constraints.maxWidth > 600;
          final horizontal = wide ? 32.0 : 20.0;
          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(horizontal, 0, horizontal, 22),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 650),
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  const StreakBadge(),
                  const ChallengeCard(),
                  const SizedBox(height: 26),
                  Row(children: [
                    const Icon(Icons.category_outlined, color: AppColors.primary, size: 19),
                    const SizedBox(width: 5),
                    Expanded(child: Text('Escolha o Tema', style: Theme.of(context).textTheme.titleLarge)),
                    if (_loadingThemes) const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                    TextButton(onPressed: _loadThemes, child: const Text('Atualizar')),
                  ]),
                  const SizedBox(height: 8),
                  if (topics.isEmpty)
                    const Text('Cadastre perguntas para começar.')
                  else
                    ...List.generate(topics.length, (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: TopicTile(
                        topic: topics[index],
                        selected: _selectedTopic == index,
                        onTap: () => setState(() => _selectedTopic = index),
                      ),
                    )),
                  const SizedBox(height: 15),
                  ScoreSummary(questionCount: _questionCount,
                    onQuestionCountChanged: (count) => setState(() => _questionCount = count)),
                  const SizedBox(height: 30),
                  SizedBox(height: 56, child: ElevatedButton.icon(
                    onPressed: _startQuiz,
                    icon: const Icon(Icons.play_arrow_rounded, size: 25),
                    label: const Text('JOGAR', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary, foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                    ),
                  )),
                  const SizedBox(height: 10),
                  Text('Tempo estimado: ~${(_questionCount * 12 / 60).ceil()} minutos',
                    textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 28),
                ]),
              ),
            ),
          );
        })),
      ]),
    );
  }
}
