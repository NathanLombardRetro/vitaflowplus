import 'package:flutter/material.dart';
import 'package:vitaflowplus/ui/login/login_page.dart';
import 'package:vitaflowplus/ui/login/auth_page.dart';
import 'package:vitaflowplus/ui/dashboard/dashboard_page.dart';
//import 'package:your_app_name/register_page.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/auth':
        return MaterialPageRoute(builder: (_) => AuthPage());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case '/dashboard':
        return MaterialPageRoute(builder: (_) => Dashboard());     
      // Add more routes here if needed
      default:
        return MaterialPageRoute(builder: (_) => Scaffold(body: Center(child: Text('No route defined for ${settings.name}'))));
    }
  }
}