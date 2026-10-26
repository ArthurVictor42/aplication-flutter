import 'package:flutter/material.dart';

class QuizTopic {
  const QuizTopic({required this.title, required this.subtitle, required this.badge, required this.icon, required this.badgeColor});
  final String title;
  final String subtitle;
  final String badge;
  final IconData icon;
  final Color badgeColor;
}
