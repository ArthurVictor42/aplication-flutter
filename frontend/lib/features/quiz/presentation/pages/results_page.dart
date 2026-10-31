
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage({
    super.key,
    required this.total,
    required this.correct,
    required this.elapsed,
    required this.onHome,
    required this.theme,
    required this.answers,
  });

  final int total;
  final int correct;
  final Duration elapsed;
  final VoidCallback onHome;
  final String theme;
  final List<Map<String, dynamic>> answers;

  @override
  Widget build(BuildContext context) {
    final wrong = total - correct;
    final percent = total == 0 ? 0 : (correct / total * 100).round();
    final minutes = elapsed.inMinutes.toString().padLeft(2, '0');
    final seconds = (elapsed.inSeconds % 60).toString().padLeft(2, '0');
    final average = total == 0 ? 0 : elapsed.inSeconds ~/ total;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: onHome, icon: const Icon(Icons.arrow_back)),
        title: const Text('Results Summary'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 650),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
              children: [
                Row(
                  children: [
                    _InfoPill(icon: Icons.translate, text: theme),
                    const SizedBox(width: 8),
                    _InfoPill(icon: Icons.timer_outlined, text: '$minutes:$seconds min'),
                    const Spacer(),
                    Text('Nível Médio', style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
                const SizedBox(height: 12),
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(18, 20, 18, 17),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          AppColors.primary.withValues(alpha: .08),
                          Theme.of(context).colorScheme.surface,
                          const Color(0xFF5DE7B1).withValues(alpha: .20),
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          width: 126,
                          height: 126,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox.expand(
                                child: CircularProgressIndicator(
                                  value: percent / 100,
                                  strokeWidth: 9,
                                  backgroundColor: AppColors.palePurple,
                                  color: AppColors.primaryLight,
                                ),
                              ),
                              Container(
                                width: 66,
                                height: 66,
                                decoration: const BoxDecoration(color: AppColors.palePurple, shape: BoxShape.circle),
                                child: const Icon(Icons.emoji_events_rounded, color: AppColors.primary, size: 34),
                              ),
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                                  decoration: BoxDecoration(color: AppColors.greenDark, borderRadius: BorderRadius.circular(12)),
                                  child: Text('$percent%', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 13),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(color: const Color(0xFFFFD9B0), borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            percent >= 80 ? '★ Excelente desempenho!' : percent >= 50 ? '★ Bom trabalho!' : 'Continue praticando!',
                            style: const TextStyle(color: Color(0xFF4A321F), fontSize: 11, fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(height: 9),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                          decoration: BoxDecoration(color: const Color(0xFFE8E9FF), borderRadius: BorderRadius.circular(13)),
                          child: Row(
                            children: [
                              const Expanded(child: Text('PONTUAÇÃO\nGERAL', textAlign: TextAlign.center,
                                style: TextStyle(color: Color(0xFF4B4B60), fontWeight: FontWeight.w700, height: 1.35))),
                              Expanded(
                                child: Text('TOTAL: $correct / $total', textAlign: TextAlign.center,
                                  style: const TextStyle(color: AppColors.primary, fontSize: 22, fontWeight: FontWeight.w900)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          percent >= 80 ? 'Você dominou a maior parte do conteúdo!' : 'Continue praticando para melhorar seu resultado!',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 13),
                _MetricCard(icon: Icons.check_circle, title: 'Quantidade de acertos',
                  subtitle: 'Respostas corretas confirmadas', value: '$correct', color: const Color(0xFF5DE7B1)),
                const SizedBox(height: 9),
                _MetricCard(icon: Icons.cancel, title: 'Quantidade de erros',
                  subtitle: 'Necessitam de revisão breve', value: '$wrong', color: const Color(0xFFFFD8D5)),
                const SizedBox(height: 13),
                Row(
                  children: [
                    Expanded(child: _SmallMetric(title: 'Precisão', value: '$percent%', icon: Icons.track_changes)),
                    const SizedBox(width: 10),
                    Expanded(child: _SmallMetric(title: 'Tempo médio', value: '${average}s', icon: Icons.speed)),
                  ],
                ),
                const SizedBox(height: 19),
                Row(
                  children: [
                    Expanded(child: Text('Detalhamento por Questão', style: Theme.of(context).textTheme.titleMedium)),
                    Text('$total perguntas', style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
                const SizedBox(height: 9),
                ...List.generate(answers.length, (index) => _AnswerReview(index: index, answer: answers[index])),
                const SizedBox(height: 18),
                SizedBox(
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: onHome,
                    icon: const Icon(Icons.refresh),
                    label: const Text('JOGAR NOVAMENTE'),
                  ),
                ),
                const SizedBox(height: 9),
                SizedBox(
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: onHome,
                    icon: const Icon(Icons.home_outlined),
                    label: const Text('Retornar ao Menu'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.icon, required this.text});
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(color: AppColors.palePurple, borderRadius: BorderRadius.circular(18)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 13, color: AppColors.primary),
      const SizedBox(width: 5),
      Text(text, style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w600)),
    ]),
  );
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.icon, required this.title, required this.subtitle, required this.value, required this.color});
  final IconData icon;
  final String title;
  final String subtitle;
  final String value;
  final Color color;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(children: [
        Container(width: 42, height: 42, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: const Color(0xFF20243A))),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
        ])),
        Container(padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
          decoration: BoxDecoration(color: color.withValues(alpha: .35), borderRadius: BorderRadius.circular(9)),
          child: Text(value, style: Theme.of(context).textTheme.titleLarge)),
      ]),
    ),
  );
}

class _SmallMetric extends StatelessWidget {
  const _SmallMetric({required this.title, required this.value, required this.icon});
  final String title;
  final String value;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: .55), borderRadius: BorderRadius.circular(14)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Expanded(child: Text(title, style: Theme.of(context).textTheme.bodySmall)), Icon(icon, color: AppColors.primary, size: 18)]),
      const SizedBox(height: 6),
      Text(value, style: Theme.of(context).textTheme.titleLarge),
    ]),
  );
}

class _AnswerReview extends StatelessWidget {
  const _AnswerReview({required this.index, required this.answer});
  final int index;
  final Map<String, dynamic> answer;

  @override
  Widget build(BuildContext context) {
    final correct = answer['correta'] == true;
    final question = (answer['pergunta'] ?? '').toString();
    final selected = (answer['selecionada'] ?? 'Não respondida').toString();
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            CircleAvatar(radius: 13, backgroundColor: AppColors.palePurple,
              child: Text('${index + 1}', style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w700))),
            const SizedBox(width: 8),
            Expanded(child: Text(question, style: Theme.of(context).textTheme.titleSmall)),
            Icon(correct ? Icons.check_circle : Icons.cancel, color: correct ? AppColors.greenDark : Colors.red),
          ]),
          const SizedBox(height: 7),
          Text('Sua resposta: $selected', style: Theme.of(context).textTheme.bodySmall),
          if (!correct && answer['resposta_correta'] != null)
            Text('Correta: ${answer['resposta_correta']}', style: const TextStyle(color: AppColors.greenDark, fontSize: 12, fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }
}
