import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class ChallengesPage extends StatelessWidget {
  const ChallengesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Desafios')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 220,
                  height: 190,
                  decoration: BoxDecoration(
                    color: AppColors.palePurple.withValues(alpha: .65),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        top: 25,
                        left: 37,
                        child: Icon(
                          Icons.star_rounded,
                          size: 25,
                          color: AppColors.primary.withValues(alpha: .45),
                        ),
                      ),
                      Positioned(
                        bottom: 30,
                        right: 28,
                        child: Icon(
                          Icons.auto_awesome_rounded,
                          size: 30,
                          color: AppColors.primary.withValues(alpha: .45),
                        ),
                      ),
                      Container(
                        width: 112,
                        height: 112,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.construction_rounded,
                          size: 58,
                          color: Colors.white,
                        ),
                      ),
                      Positioned(
                        right: 32,
                        top: 27,
                        child: Container(
                          padding: const EdgeInsets.all(9),
                          decoration: const BoxDecoration(
                            color: AppColors.green,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.hourglass_top_rounded,
                            color: Color(0xFF12664E),
                            size: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Text(
                  'Em desenvolvimento',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 9),
                Text(
                  'Estamos preparando novos desafios para você. Em breve esta área terá novidades!',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.palePurple,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'NOVOS RECURSOS EM BREVE',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: .5,
                    ),
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
