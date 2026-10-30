import 'package:flutter/material.dart';

class ChallengesPage extends StatelessWidget {
  const ChallengesPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Desafios')),
    body: ListView(padding: const EdgeInsets.all(20), children: [
      Card(child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.local_fire_department)),
        title: const Text('Desafio diário'),
        subtitle: const Text('Responda a uma sequência de perguntas para praticar.'),
        trailing: const Chip(label: Text('Disponível')),
      )),
      Card(child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.emoji_events_outlined)),
        title: const Text('Conquistas'),
        subtitle: const Text('As conquistas e o ranking serão habilitados quando o backend tiver suporte a perfis e histórico.'),
      )),
    ]),
  );
}
