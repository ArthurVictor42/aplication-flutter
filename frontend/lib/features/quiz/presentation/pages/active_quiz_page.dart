import 'package:flutter/material.dart';
import '../../../../core/network/quiz_api_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../home/presentation/pages/home_page.dart';
import 'results_page.dart';

class ActiveQuizPage extends StatefulWidget {
  const ActiveQuizPage({super.key, required this.launch, required this.onExit});
  final QuizLaunch launch;
  final VoidCallback onExit;

  @override
  State<ActiveQuizPage> createState() => _ActiveQuizPageState();
}

class _ActiveQuizPageState extends State<ActiveQuizPage> {
  int _index = 0;
  int? _selected;
  bool _checking = false;
  int _correct = 0;
  final Stopwatch _stopwatch = Stopwatch()..start();

  Map<String, dynamic> get _question => widget.launch.questions[_index];
  List<Map<String, dynamic>> get _alternatives =>
      (_question['alternativas'] as List).cast<Map<String, dynamic>>();

  Future<void> _confirm() async {
    if (_selected == null || _checking) return;
    setState(() => _checking = true);
    try {
      final isCorrect = await QuizApiService.verificarResposta(
        idPergunta: (_question['id_questao'] as num).toInt(),
        idAlternativa: (_alternatives[_selected!]['id_alternativa'] as num).toInt(),
      );
      if (!mounted) return;
      if (isCorrect) _correct++;
      if (_index == widget.launch.questions.length - 1) {
        _stopwatch.stop();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => ResultsPage(
            total: widget.launch.questions.length,
            correct: _correct,
            elapsed: _stopwatch.elapsed,
            onHome: widget.onExit,
          ),
        ));
      } else {
        setState(() { _index++; _selected = null; });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao confirmar resposta: $e')));
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = _question;
    final progress = (_index + 1) / widget.launch.questions.length;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: widget.onExit, icon: const Icon(Icons.arrow_back)),
        title: const Text('Quiz em andamento'),
        centerTitle: true,
      ),
      body: SafeArea(child: Center(child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Row(children: [
              Chip(label: Text(widget.launch.theme ?? 'Todos os temas')),
              const Spacer(),
              Text('${_index + 1} / ${widget.launch.questions.length}', style: Theme.of(context).textTheme.titleMedium),
            ]),
            const SizedBox(height: 10),
            ClipRRect(borderRadius: BorderRadius.circular(20), child: LinearProgressIndicator(value: progress, minHeight: 8)),
            const SizedBox(height: 22),
            Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('QUESTÃO ${_index + 1} • ${(q['tema'] ?? '').toString().toUpperCase()}',
                style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 12)),
              const SizedBox(height: 18),
              Text((q['cabecalho'] ?? '').toString(), style: Theme.of(context).textTheme.headlineSmall),
            ]))),
            const SizedBox(height: 18),
            Expanded(child: ListView.separated(
              itemCount: _alternatives.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final selected = _selected == i;
                return Material(
                  color: selected ? AppColors.primary.withValues(alpha: .13) : Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(14),
                  child: InkWell(
                    onTap: _checking ? null : () => setState(() => _selected = i),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: selected ? AppColors.primary : Theme.of(context).dividerColor)),
                      child: Row(children: [
                        CircleAvatar(radius: 17, backgroundColor: selected ? AppColors.primary : AppColors.palePurple,
                          child: Text(String.fromCharCode(65 + i), style: TextStyle(color: selected ? Colors.white : AppColors.primary, fontWeight: FontWeight.bold))),
                        const SizedBox(width: 12),
                        Expanded(child: Text((_alternatives[i]['texto_alternativa'] ?? '').toString(),
                          style: Theme.of(context).textTheme.titleMedium)),
                        if (selected) const Icon(Icons.check_circle, color: AppColors.primary),
                      ]),
                    ),
                  ),
                );
              },
            )),
            const SizedBox(height: 12),
            SizedBox(height: 54, child: ElevatedButton(
              onPressed: _selected == null || _checking ? null : _confirm,
              child: _checking ? const CircularProgressIndicator() : Text(_index == widget.launch.questions.length - 1 ? 'FINALIZAR QUIZ' : 'CONFIRMAR RESPOSTA  →'),
            )),
          ]),
        ),
      ))),
    );
  }
}
