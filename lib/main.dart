import 'package:flutter/material.dart';
import 'package:provider_state/provider/count_provider.dart';
import 'package:provider_state/provider/favourite_provider.dart';
import 'package:provider_state/provider/slider_provider.dart';
import 'package:provider_state/provider/theme_provider.dart';
import 'package:provider_state/screens/count_example.dart';
import 'package:provider/provider.dart';
import 'package:provider_state/screens/favourite_screen.dart';
import 'package:provider_state/screens/slider_screen.dart';
import 'package:provider_state/screens/theme_changer_screen.dart';
import 'package:provider_state/screens/value_notifier_listner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CountProvider()),
        ChangeNotifierProvider(create: (_) => SliderProvider()),
        ChangeNotifierProvider(create: (_) => FavouriteProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],

      child: Builder(
        builder: (BuildContext context) {
          final themeProvider = Provider.of<ThemeProvider>(context);
          return MaterialApp(
            debugShowCheckedModeBanner: false,

            themeMode:
                themeProvider.isdarktheme ? ThemeMode.dark : ThemeMode.light,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              iconTheme: IconThemeData(color: Colors.blue),
              appBarTheme: AppBarTheme(color: Colors.blue),
            ),

            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primarySwatch: Colors.red,
              primaryColor: Colors.red,
              iconTheme: IconThemeData(color: Colors.teal),
              appBarTheme: AppBarTheme(color: Colors.teal),
            ),
            home: ValueNotifierListner(),
          );
        },
      ),
    );
  }
}
