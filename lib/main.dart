import 'package:appbase/base/initialize_app.dart';
import 'package:appbase/config/providers_config.dart';
import 'package:appbase/config/theme_config.dart';
import 'package:appbase/ui/theme/theme_config_provider.dart';
import 'package:document_manager/repository/provider/app_provider.dart';
import 'package:document_manager/screen/changePassword.dart';
import 'package:document_manager/screen/login.dart';
import 'package:document_manager/screen/onboardingScreen.dart';
import 'package:document_manager/screen/splashScreen.dart';
import 'package:document_manager/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';


import 'comms/helper.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  ThemeConfig.instance.setStatusBarColor(Themer.textColor);
  ThemeConfig.instance.setAppPrimaryColor(Themer.gradient1);
  ProvidersConfig.instance.registerProviders(providers);
  InitializeApp().initialLizeApp(const MyApp());
}



final GoRouter _router = GoRouter(
  routes: [

  GoRoute(
    path: "/",
    builder: (context, state) =>  OnboardingScreen(),
  ),

  GoRoute(
    path: '/home',
    builder: (BuildContext context, GoRouterState state) => const SplashScreen(),
  ),

  GoRoute(
      path: "/change-password/:userId/:token",
      name: "change-password",
      builder: (BuildContext context, GoRouterState state) {
        ///supports deeplink http://document.app/change-password/:userId/:token
        final userId = state.pathParameters['userId'] ?? '';
        final token = state.pathParameters['token'] ?? '';
        return ChangePassword(token: token, userId: userId,);
      },
    ),
],
  redirect: (BuildContext context, GoRouterState state) {
    final Uri? uri = state.uri;
    if (uri != null && uri.pathSegments.isNotEmpty) {
      if (uri.pathSegments.first == "change-password" && uri.pathSegments.length >= 3) {
        final userId = uri.pathSegments[1];
        final token = uri.pathSegments[2];
        return '/change-password/$userId/$token';
      }
    }
    return null;
  },

);

class MyApp extends StatefulWidget {

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver  {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    handleInitialUri();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      handleInitialUri(); // Handle when app comes back to the foreground
    }
  }

  Future<void> handleInitialUri() async {
    final initialUri = await Uri.base; // Gets the initial deep link
    if (initialUri != null) {
      _handleUri(initialUri);
    }
  }

  void _handleUri(Uri uri) {
    final path = uri.path;
    if (path.startsWith('/change-password')) {
      final segments = uri.pathSegments;
      final userId = segments.length > 1 ? segments[1] : '';
      final token = segments.length > 2 ? segments[2] : '';
      if (userId.isNotEmpty && token.isNotEmpty) {
        GoRouter.of(context).go('/change-password/$userId/$token');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: ProvidersConfig.instance.providers,
      child: Consumer<ThemeConfigProvider>(
        builder: (context, themeChanger, child) {
          return AnnotatedRegion(
            value: SystemUiOverlayStyle(
              statusBarColor: ThemeConfig.instance.statusBarColor,
            ),
            child: SafeArea(
                child: MaterialApp(
                  title: "Document Manager",
                  debugShowCheckedModeBanner: false,
                  scaffoldMessengerKey: scaffoldMessengerKey,
                  home: MaterialApp.router(
                    debugShowCheckedModeBanner: false,
                    routerConfig: _router,
                  ),
                  theme: themeChanger.hasThemePreference ? themeChanger.themeData : ThemeConfig.instance.lightTheme,
                  darkTheme: themeChanger.hasThemePreference ? themeChanger.themeData : ThemeConfig.instance.darkTheme,
                )
            ),
          );
        },

      ),
    );
  }
}
