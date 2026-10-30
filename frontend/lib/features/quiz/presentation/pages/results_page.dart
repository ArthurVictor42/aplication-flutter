import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage({super.key, required this.total, required this.correct, required this.elapsed, required this.onHome});
  final int total;
  final int correct;
  final Duration elapsed;
  final VoidCallback onHome;

  @override
  Widget build(BuildContext context) {
    final wrong = total - correct;
    final percent = total == 0 ? 0 : (correct / total * 100).round();
    final minutes = elapsed.inMinutes.toString().padLeft(2, '0');
    final seconds = (elapsed.inSeconds % 60).toString().padLeft(2, '0');
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false, title: const Text('Resumo dos resultados'), centerTitle: true),
      body: SafeArea(child: Center(child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 650),
        child: ListView(padding: const EdgeInsets.all(20), children: [
          Card(child: Padding(padding: const EdgeInsets.all(24), child: Column(children: [
            SizedBox(width: 140, height: 140, child: Stack(alignment: Alignment.center, children: [
              SizedBox.expand(child: CircularProgressIndicator(value: percent / 100, strokeWidth: 10, backgroundColor: AppColors.palePurple)),
              Column(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.emoji_events_rounded, color: AppColors.primary, size: 35),
                Text('$percent%', style: Theme.of(context).textTheme.headlineSmall),
              ]),
            ])),
            const SizedBox(height: 18),
            Text(percent >= 80 ? 'Excelente desempenho!' : percent >= 50 ? 'Bom trabalho!' : 'Continue praticando!',
              style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Pontuação geral: $correct / $total', style: Theme.of(context).textTheme.titleMedium),
            Text('Tempo total: $minutes:$seconds', style: Theme.of(context).textTheme.bodyMedium),
          ]))),
          const SizedBox(height: 14),
          _MetricCard(icon: Icons.check_circle, title: 'Quantidade de acertos', subtitle: 'Respostas corretas confirmadas', value: '$correct', color: const Color(0xFF5DE7B1)),
          const SizedBox(height: 10),
          _MetricCard(icon: Icons.cancel, title: 'Quantidade de erros', subtitle: 'Respostas que precisam de revisão', value: '$wrong', color: const Color(0xFFFFD8D5)),
          const SizedBox(height: 24),
          SizedBox(height: 54, child: ElevatedButton.icon(onPressed: onHome, icon: const Icon(Icons.refresh), label: const Text('JOGAR NOVAMENTE'))),
          const SizedBox(height: 10),
          OutlinedButton.icon(onPressed: onHome, icon: const Icon(Icons.home_outlined), label: const Text('Retornar ao Menu')),
        ]),
      ))),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.icon, required this.title, required this.subtitle, required this.value, required this.color});
  final IconData icon;
  final String title;
  final String subtitle;
  final String value;
  final Color color;
  @override
  Widget build(BuildContext context) => Card(child: Padding(
    padding: const EdgeInsets.all(14),
    child: Row(children: [
      CircleAvatar(backgroundColor: color, child: Icon(icon, color: const Color(0xFF20243A))),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
      ])),
      Text(value, style: Theme.of(context).textTheme.headlineSmall),
    ]),
  ));
}
