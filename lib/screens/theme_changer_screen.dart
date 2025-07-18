import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_state/provider/theme_provider.dart';

class ThemeChangerScreen extends StatefulWidget {
  const ThemeChangerScreen({super.key});

  @override
  State<ThemeChangerScreen> createState() => _ThemeChangerScreenState();
}

class _ThemeChangerScreenState extends State<ThemeChangerScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Theme Changer"),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SwitchListTile(
            value: themeProvider.isdarktheme,
            activeColor: Colors.teal,
            title: Text("Dark Mode"),
            onChanged: (val) {
              themeProvider.setTheme(val);
            },
          ),
          SwitchListTile(
            value: !themeProvider.isdarktheme,
            activeColor: Colors.blue,
            title: Text("Light Mode"),
            onChanged: (val) {
              themeProvider.setTheme(!val);
            },
          ),
          SizedBox(height: 20),
          Icon(Icons.favorite, size: 60),
        ],
      ),
    );
  }
}
