import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:space_beacon/app/app_routes.dart';
import 'package:space_beacon/ui/home/home_screen.dart';
import 'package:space_beacon/ui/home/home_screen_controller.dart';
import 'package:space_beacon/ui/signin/signin_screen.dart';
import '../home/mock_home_screen_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  var pages = [
    GetPage(
      name: AppRoute.signIn,
      page: () => SignInScreen(),
    ),
    GetPage(
      name: AppRoute.home,
      page: () => HomeScreen(),
    ),
  ];
  testWidgets('HomeScreen issNow data fetch should success',
      (WidgetTester tester) async {
    // Arrange
    final mockHomeController = MockHomeScreenController();
    Get.put<HomeScreenController>(mockHomeController);

    // Act
    await tester.pumpWidget(
      GetMaterialApp(
        initialRoute: AppRoute.home,
        getPages: pages,
        home: HomeScreen(),
      ),
    );

    // Assert initial UI AppBar
    expect(find.text("Space Beacon"), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
    await tester.pump(); // rebuild UI

    expect(mockHomeController.issNow.value?.message, "success");

    await tester.pumpAndSettle();
  });
}
