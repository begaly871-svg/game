import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app.dart';

void main() => runApp(const YurtStackApp());

class YurtStackApp extends StatelessWidget {
  const YurtStackApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Yurt Stack',
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Trebuchet MS',
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xffd9473a)),
          scaffoldBackgroundColor: const Color(0xfffff9ed),
        ),
        supportedLocales: const [Locale('ru'), Locale('en'), Locale('ky')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: const YurtHome(),
      );
}
