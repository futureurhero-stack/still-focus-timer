import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:momo/app.dart';

void main() {
  testWidgets('FocusFlow app loads successfully', (WidgetTester tester) async {
    // FocusFlowApp 위젯을 빌드합니다.
    await tester.pumpWidget(
      const ProviderScope(
        child: FocusFlowApp(),
      ),
    );

    // 앱 이름이 표시되는지 확인
    expect(find.text('FocusFlow'), findsOneWidget);
  });
}
