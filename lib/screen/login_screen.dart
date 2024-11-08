import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/services.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _setupAuthListener();
  }

  void _setupAuthListener() {
    supabase.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;
      
      if (event == AuthChangeEvent.signedIn && session != null) {
        final user = session.user;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              userEmail: user.email ?? '',
              userName: user.userMetadata?['full_name'] ?? '',
            ),
          ),
        );
      }
    });
  }

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    try {
      print('로그인 시도');
      await supabase.auth.signInWithOAuth(
        Provider.google,
        redirectTo: 'io.supabase.flutter://login-callback/',
        authScreenLaunchMode: LaunchMode.externalApplication,
      );
      
      print('로그인 시도 완료');
    } catch (e) {
      print('로그인 에러: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('로그인에 실패했습니다: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;  // 뒤로가기 비활성화
      },
      child: Scaffold(
        backgroundColor: Color(0xFF3E5175),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'CLASS IN',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'IrishGrover',
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.only(left: 30),
                child: Image.asset(
                  'lib/image/logo.png',
                  height: 150,
                ),
              ),
              SizedBox(height: 30),
              InkWell(
                onTap: () {
                  print('버튼 클릭됨');
                  _handleGoogleSignIn(context);
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color(0xFF3E5175),
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'lib/image/google_logo.png',
                    height: 40,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 