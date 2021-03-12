import 'package:DevJurnal_new_world/constant/named_navigation_collection.dart';
import 'package:DevJurnal_new_world/view/autehntication/auth_view/login_page.dart';
import 'package:DevJurnal_new_world/view/autehntication/auth_view/login_page_2.dart';
import 'package:DevJurnal_new_world/view/autehntication/auth_view/otp_page.dart';
import 'package:DevJurnal_new_world/view/autehntication/auth_view/sing_up.dart';
import 'package:DevJurnal_new_world/view/home_page.dart';
import 'package:flutter/animation.dart';
import 'package:sailor/sailor.dart';

class Routes {
  static final sailor = Sailor();

  static void createRoutes() {
    sailor.addRoutes([
      SailorRoute(
        name: SignUpNavigation,
        builder: (context, args, params) {
          return SingUp();
        },
        defaultTransitions: [SailorTransition.slide_from_bottom],
        defaultTransitionCurve: Curves.ease,
        defaultTransitionDuration: Duration(milliseconds: 500),
      ),
      SailorRoute(
          name: OtpNavigation,
          builder: (context, args, params) {
            return OtpPage(
              tokenAccess: params.param('otp'),
            );
          },
          params: [SailorParam(name: 'otp', isRequired: true)]),
      SailorRoute(
        name: SignInNavigation,
        builder: (context, args, params) {
          return LoginPage();
        },
        defaultTransitions: [SailorTransition.slide_from_bottom],
        defaultTransitionCurve: Curves.ease,
        defaultTransitionDuration: Duration(milliseconds: 500),
      ),
      SailorRoute(
        name: SignInNavigation,
        builder: (context, args, params) {
          return LoginPage();
        },
        defaultTransitions: [SailorTransition.slide_from_bottom],
        defaultTransitionCurve: Curves.ease,
        defaultTransitionDuration: Duration(milliseconds: 500),
      ),
      SailorRoute(
        name: HomeNavigtion,
        builder: (context, args, params) {
          return HomePageHook();
        },
      ),
    ]);
  }
}

void navigateToPage(String namedNavigate,
    {bool status = true, String otp = ""}) {
  Routes.sailor.navigate(namedNavigate,
      params:
          otp.isNotEmpty && namedNavigate == OtpNavigation ? {'otp': otp} : {},
      navigationType:
          status ? NavigationType.pushReplace : NavigationType.push);
}
