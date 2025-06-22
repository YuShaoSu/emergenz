import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/nav_screen.dart';
import 'screens/procedure_detail_screen.dart';
import 'l10n/app_localizations.dart';
import 'models/emergency_procedure.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emergency App',
      debugShowCheckedModeBanner: false,
      // just a workaroud to force show zh
      locale: const Locale('zh'),
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        return const Locale('zh');
      },
      // workaround end
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'SF Pro',
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0.5,
        ),
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: NavScreen(),
      onGenerateRoute: (settings) {
        if (settings.name == '/procedure-detail') {
          final procedure = settings.arguments as EmergencyProcedure;
          return MaterialPageRoute(
            builder: (context) => ProcedureDetailScreen(procedure: procedure),
          );
        }
        // Add more routes here as needed
        return MaterialPageRoute(
          builder: (context) => NavScreen(),
        );
      },
    );
  }
}
