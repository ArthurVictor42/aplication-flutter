import 'package:flutter/material.dart';
import '../domain/quiz_topic.dart';

const quizTopics = <QuizTopic>[
  QuizTopic(title: 'Inglês', subtitle: 'Gramática, Vocabulário e Expressões', badge: 'Popular', icon: Icons.translate_rounded, badgeColor: Color(0xFF5DE7B1)),
  QuizTopic(title: 'Gerais', subtitle: 'História, Geografia e Cultura Pop', badge: 'Clássico', icon: Icons.public_rounded, badgeColor: Color(0xFFE8E9FF)),
  QuizTopic(title: 'Tecnologia', subtitle: 'Inovação, IA, Web & Código', badge: 'Pro', icon: Icons.terminal_rounded, badgeColor: Color(0xFFFFD8A8)),
];
