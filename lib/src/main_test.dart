import 'app_flow_integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main({bool hasMemberTools = true}) {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  testWidgets('Complete IntegrationTest', (tester) async {
    await integrationTestFlow(tester, binding);
  });
}
