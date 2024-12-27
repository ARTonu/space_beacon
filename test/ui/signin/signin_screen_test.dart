import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:space_beacon/app/app_routes.dart';
import 'package:space_beacon/ui/home/home_screen.dart';
import 'package:space_beacon/ui/home/home_screen_controller.dart';
import 'package:space_beacon/ui/signin/signin_screen.dart';
import 'package:space_beacon/ui/signin/signin_screen_controller.dart';
import '../home/mock_home_screen_controller.dart';
import 'mock_signin_screen_controller.dart';

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
  testWidgets(
      'SignInScreen should navigate to HomeScreen on successful sign-in',
      (WidgetTester tester) async {
    // Arrange
    final mockController = MockSignInScreenController();
    Get.put<SignInScreenController>(mockController);

    final mockHomeController = MockHomeScreenController();
    Get.put<HomeScreenController>(mockHomeController);

    // Act
    await tester.pumpWidget(
      GetMaterialApp(
        initialRoute: AppRoute.signIn,
        getPages: pages,
        home: SignInScreen(),
      ),
    );

    // Assert initial UI AppBar
    expect(find.text("Space Beacon"), findsOneWidget);

    // Check loading UI
    mockController.isSingingIn.value = true;
    await tester.pump();
    expect(find.text("Please wait..."), findsOneWidget);

    // Complete signing in
    mockController.isSingingIn.value = false;
    mockController.isSingInSuccess.value = false;
    mockController.result.value = "You are now signed in";
    await tester.pumpAndSettle(); // Allow animations to finish

    // Trigger signing in
    await tester.pump(const Duration(seconds: 2));
    await tester.pump(); // Rebuild widget after sign-in success
    expect(find.text("Please wait..."), findsNothing);
    await tester.pumpAndSettle(const Duration(seconds: 2));
    expect(Get.currentRoute, AppRoute.home);
  });
}
