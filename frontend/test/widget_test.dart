
import 'package:flutter_test/flutter_test.dart';
import 'package:question/app.dart';

void main() {
  testWidgets('A tela inicial do Quiz Motion é exibida',
      (WidgetTester tester) async {
    await tester.pumpWidget(const QuizMotionApp());

    expect(find.text('Quiz Motion'), findsOneWidget);
    expect(find.text('Escolha o Tema'), findsOneWidget);
    expect(find.text('JOGAR'), findsOneWidget);
  });
}