import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/network/quiz_api_service.dart';
import '../../../home/data/quiz_topics.dart';
import '../../../home/presentation/widgets/home_header.dart';
import '../../widgets/create_header.dart';
import '../../widgets/option_tile.dart';
import '../../widgets/quality_notice.dart';
import '../../widgets/question_field.dart';
import '../../widgets/section_label.dart';
import '../../widgets/topic_selector.dart';

class CreateQuestionPage extends StatefulWidget {
  const CreateQuestionPage({super.key, this.onBack});

  /// Chamado pelo botão voltar. O shell passa a troca para a aba 0.
  final VoidCallback? onBack;

  @override
  State<CreateQuestionPage> createState() => _CreateQuestionPageState();
}

class _CreateQuestionPageState extends State<CreateQuestionPage> {
  // --- Estado: tudo que a tela precisa lembrar ---
  final _questionController = TextEditingController();
  final _optionControllers = List.generate(4, (_) => TextEditingController());
  int? _correctIndex; // null = nenhuma marcada ainda
  int _topicIndex = 0;

  @override
  void initState() {
    super.initState();
    // Qualquer campo que mude redesenha a tela, para o botão
    // "Aplicar Pergunta" habilitar/desabilitar.
    _questionController.addListener(_refresh);
    for (final c in _optionControllers) {
      c.addListener(_refresh);
    }
  }

  void _refresh() => setState(() {});

  @override
  void dispose() {
    _questionController.dispose();
    for (final c in _optionControllers) {
      c.dispose();
    }
    super.dispose();
  }

  // --- Regras ---

  /// Pergunta preenchida + 4 alternativas preenchidas + uma correta marcada.
  bool get _isValid =>
      _questionController.text.trim().isNotEmpty &&
      _optionControllers.every((c) => c.text.trim().isNotEmpty) &&
      _correctIndex != null;

  void _clear() {
    _questionController.clear();
    for (final c in _optionControllers) {
      c.clear();
    }
    setState(() => _correctIndex = null);
  }

  Future<void> _submit() async {
    final alternativas = List.generate(
      _optionControllers.length,
      (i) => <String, dynamic>{
        'texto_alternativa': _optionControllers[i].text.trim(),
        'correta': _correctIndex == i,
      },
    );

    try {
      await QuizApiService.criarPergunta(
        cabecalho: _questionController.text.trim(),
        tema: quizTopics[_topicIndex].title,
        alternativas: alternativas,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pergunta salva no MySQL com sucesso!')),
      );
      _clear();
    } catch (e) {
      if (!mounted) return;
      final message = e.toString().replaceFirst('Exception: ', '');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não foi possível salvar: $message')),
      );
    }
  }

  /// Converte os temas disponíveis para o formato visual do seletor.
  List<TopicOption> get _topicOptions => quizTopics
      .map(
        (t) => TopicOption(
          code: t.title.substring(0, 2).toUpperCase(),
          title: t.title,
          subtitle: 'Vocabulário, Expressões & Gramática',
        ),
      )
      .toList();

  // --- Interface ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Header fixo + conteúdo rolável, como na home.
      body: Column(
        children: [
          HomeHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 22),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 650),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CreateHeader(onBack: widget.onBack),
                      const SizedBox(height: 16),

                      const SectionLabel(
                        icon: Icons.category_outlined,
                        title: 'Tema / Matéria',
                        trailing: ActiveStatus(),
                      ),
                      const SizedBox(height: 8),
                      TopicSelector(
                        topics: _topicOptions,
                        selectedIndex: _topicIndex,
                        onChanged: (i) => setState(() => _topicIndex = i),
                      ),
                      const SizedBox(height: 20),

                      QuestionField(controller: _questionController),
                      const SizedBox(height: 20),

                      const SectionLabel(
                        icon: Icons.format_list_bulleted,
                        title: 'Alternativas',
                        trailing: HintPill('Marque a correta'),
                      ),
                      const SizedBox(height: 8),
                      // String.fromCharCode(65 + i): 65 = 'A', 66 = 'B'...
                      ...List.generate(
                        4,
                        (i) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: OptionTile(
                            letter: String.fromCharCode(65 + i),
                            controller: _optionControllers[i],
                            selected: _correctIndex == i,
                            onSelected: () => setState(() => _correctIndex = i),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      const QualityNotice(),
                      const SizedBox(height: 24),

                      SizedBox(
                        height: 56,
                        child: ElevatedButton.icon(
                          // onPressed null desabilita o botão automaticamente.
                          onPressed: _isValid ? _submit : null,
                          icon: const Icon(Icons.add_task_rounded, size: 22),
                          label: const Text(
                            'Aplicar Pergunta',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: AppColors.primary
                                .withValues(alpha: .4),
                            disabledForegroundColor: Colors.white70,
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
                      const SizedBox(height: 6),
                      TextButton(
                        onPressed: _clear,
                        child: const Text(
                          'Limpar Campos',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.muted,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
