import 'package:flutter_test/flutter_test.dart';
import 'package:stu/data/repository/coin_repository.dart';
import 'package:stu/data/service/api_service.dart';
import 'package:stu/main.dart';


void main() {
  testWidgets(
    'CryptoTracker app smoke test',
        (WidgetTester tester) async {
      final apiService = ApiService();

      final repository = CoinRepository(
        apiService: apiService,
      );

      await tester.pumpWidget(
        MyApp(
          repository: repository,
        ),
      );

      await tester.pump();

      expect(
        find.text('CryptoTracker'),
        findsOneWidget,
      );
    },
  );
}