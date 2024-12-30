import 'package:appbase/base/initialize_app.dart';
import 'package:appbase/config/providers_config.dart';
import 'package:appbase/config/theme_config.dart';
import 'package:appbase/ui/theme/theme_config_provider.dart';
import 'package:document_manager/repository/provider/app_provider.dart';
import 'package:document_manager/screen/login.dart';
import 'package:document_manager/screen/onboardingScreen.dart';
import 'package:document_manager/screen/splashScreen.dart';
import 'package:document_manager/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'comms/helper.dart';

// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatefulWidget {
//   const MyApp({super.key});
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   bool _isDarkMode = false;
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Document Manager',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
//         useMaterial3: true,
//       ),
//       // theme: ThemeData.light(),
//       darkTheme: ThemeData.dark(),
//       themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
//       initialRoute: '/',
//       // routes: Helper.routes,
//       routes: {
//         '/': (context) => OnboardingScreen(),
//         '/home': (context) => SplashScreen(), // Define your main screen here
//       },
//
//
//       //   home: const SplashScreen(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ThemeConfig.instance.setStatusBarColor(Themer.textColor);
  ThemeConfig.instance.setAppPrimaryColor(Themer.gradient1);
  ProvidersConfig.instance.registerProviders(providers);
  InitializeApp().initialLizeApp(const MyApp());
}


class MyApp extends StatelessWidget {

  const MyApp({super.key});

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
                  // home: MaterialApp.router(
                  //   debugShowCheckedModeBanner: false,
                  // ),
                  initialRoute: '/',
                  // routes: Helper.routes,
                  routes: {
                    '/': (context) => OnboardingScreen(),
                    '/home': (context) => SplashScreen(), // Define your main screen here
                  },
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
