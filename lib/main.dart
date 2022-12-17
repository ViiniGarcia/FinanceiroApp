import 'package:dynamic_color/dynamic_color.dart';
import 'package:financeiro/principal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'helpers/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: "financeiro",
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Financeiro',
      theme: ThemeData(
        cardColor: Theme.of(context).colorScheme.surface,
        indicatorColor: const Color(0XFF6750A4),
        colorScheme: const ColorScheme.light(),
        tabBarTheme: const TabBarTheme(
          labelColor: Colors.black,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        indicatorColor: const Color(0XFFD0BCFF),
        colorScheme: const ColorScheme.dark(),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('es', ''),
        Locale('pt', 'BR')
      ],
      themeMode: ThemeMode.system,
      home: const Principal(),
    );
  }
}
