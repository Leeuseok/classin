import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://bgkuufskrzxcfgkaavok.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJna3V1ZnNrcnp4Y2Zna2Fhdm9rIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzA3MDIzODcsImV4cCI6MjA0NjI3ODM4N30.S6yDQNE5VqRlXFTWE24n44K0vqz25M5AipsVbiqO4gg',
  );
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CLASS IN',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
