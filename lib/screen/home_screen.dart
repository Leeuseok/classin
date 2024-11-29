import 'package:chool_check/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // iOS 스타일 위젯 사용을 위해 추가
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async'; // Timer를 사용하기 위해 추가
import 'package:intl/intl.dart'; // 시간 포맷을 위해 추가 (pubspec.yaml에서 intl 패키지 의존성 추가)
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class HomeScreen extends StatefulWidget {
  final String userEmail;
  final String userName;

  const HomeScreen({
    Key? key,
    required this.userEmail,
    required this.userName,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final supabase = Supabase.instance.client;
  Timer? timer;
  bool _isDisposed = false;
  bool _imagesLoaded = false; // 이미지 로딩 상태 체크

  static final LatLng companyLatLng = LatLng(
    35.87129989814521, // 위도
    128.60418094698616, // 경도
  );

  static final Marker marker = Marker(
    markerId: MarkerId('company'),
    position: companyLatLng,
  );

  static final Circle circle = Circle(
    circleId: CircleId('schoolCheckCircle'),
    center: companyLatLng,
    fillColor: Colors.blue.withOpacity(0.5),
    radius: 100,
    strokeColor: Colors.blue,
    strokeWidth: 1,
  );

  String currentTime = '';
  final String professorEmail = 'dndntjr12@g.yju.ac.kr'; // 교수님의 이메일 주소

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_imagesLoaded) {
      // 이미지 precache
      precacheImage(AssetImage('lib/image/logo.png'), context);
      _imagesLoaded = true;
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    timer?.cancel();
    super.dispose();
  }

  Future<void> _handleSignOut() async {
    try {
      timer?.cancel();
      await supabase.auth.signOut();

      if (!mounted) return;

      await Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      print('로그아웃 에러: $e');
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그아웃에 실패했습니다: $e')),
      );
    }
  }

  Future<void> saveAttendance(double latitude, double longitude) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        print('사용자가 로그인되어 있지 않습니다.');
        return;
      }

      // 데이터 저장 전에 로그 출력
      print('저장할 데이터: ${{
        'user_id': user.id,
        'user_email': widget.userEmail,
        'user_name': widget.userName,
        'location_latitude': latitude,
        'location_longitude': longitude,
        'check_in_time': DateTime.now().toIso8601String(),
      }}');

      final response = await supabase.from('attendance').insert({
        'user_id': user.id,
        'user_email': user.email, // 여기서 Supabase 사용자 이메일 사용
        'user_name': widget.userName,
        'location_latitude': latitude,
        'location_longitude': longitude,
        'check_in_time': DateTime.now().toIso8601String(),
      }).execute();

      print('출석 저장 응답: $response');

      if (response.error != null) {
        print('출석 저장 실패: ${response.error!.message}');
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('출석 저장에 실패했습니다: ${response.error!.message}')),
        );
      } else {
        // 이메일 전송 함수 호출
        await sendWelcomeEmail(widget.userName);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('출석이 완료되었습니다.')),
        );
      }
    } catch (e) {
      print('출석 저장 중 예외 발생: $e');
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('출석 저장에 실패했습니다. 상세 오류: $e')),
      );
    }
  }

  String _formatTime(DateTime time) {
    return DateFormat('HH : mm : ss').format(time);
  }

  Future<void> sendWelcomeEmail(String userName) async {
    String username = 'dntjr4646@gmail.com'; // 발신자 이메일
    String password = 'icyh cfpp oitk hmms'; // 생성된 앱 비밀번호

    final smtpServer = gmail(username, password); // Gmail SMTP 서버 사용

    final message = Message()
      ..from = Address(username, 'CLASS IN') // 발신자 정보
      ..recipients.add(professorEmail) // 교수님 이메일
      ..subject = 'CLASS IN'
      ..text = '학생 $userName의 출석이 완료되었습니다.\n출석 시간: $currentTime';

    try {
      final sendReport = await send(message, smtpServer);
      print('이메일 전송 성공: ${sendReport.toString()}');
    } catch (e) {
      print('이메일 전송 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Color(0xFF3E5175),
        appBar: AppBar(
          backgroundColor: Color(0xFF3E5175),
          elevation: 0,
          title: Text(
            'CLASS IN',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
              fontFamily: 'IrishGrover',
            ),
          ),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: Icon(Icons.logout, color: Colors.white),
              onPressed: () async {
                final bool? confirm = await showCupertinoDialog<bool>(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                    title: Text('로그아웃'),
                    content: Text('정말 로그아웃 하시겠습니까?'),
                    actions: [
                      CupertinoDialogAction(
                        isDestructiveAction: true,
                        onPressed: () => Navigator.pop(context, false),
                        child: Text('취소'),
                      ),
                      CupertinoDialogAction(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text('확인'),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  await _handleSignOut();
                }
              },
            ),
          ],
        ),
        body: FutureBuilder<String>(
            future: checkPermission(),
            builder: (context, snapshot) {
              if (!snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.data == '위치 권한이 허가 되었습니다.') {
                return Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: companyLatLng,
                          zoom: 16,
                        ),
                        myLocationEnabled: true,
                        markers: Set.from([marker]),
                        circles: Set.from([circle]),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _formatTime(now),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 55,
                              fontFamily: 'LAB디지털',
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          ElevatedButton(
                            onPressed: () async {
                              final curPosition =
                                  await Geolocator.getCurrentPosition();

                              final distance = Geolocator.distanceBetween(
                                curPosition.latitude,
                                curPosition.longitude,
                                companyLatLng.latitude,
                                companyLatLng.longitude,
                              );

                              if (!mounted) return;

                              if (distance < 100) {
                                await saveAttendance(
                                  curPosition.latitude,
                                  curPosition.longitude,
                                );
                                _showAttendanceSuccessDialog();
                              } else {
                                // 출석 실패 다이얼로그 표시
                                showCupertinoDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CupertinoAlertDialog(
                                      title: const Text('출석 실패'),
                                      content: Text(
                                        '출석 가능 지역이 아닙니다.',
                                      ),
                                      actions: [
                                        CupertinoDialogAction(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('확인'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: const CircleBorder(),
                            ),
                            child: const Icon(
                              Icons.check_circle,
                              size: 100.0,
                              color: Color(0xFF2DC193),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }

              return Center(child: Text(snapshot.data.toString()));
            }),
      ),
    );
  }

  void _showAttendanceSuccessDialog() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('출석 완료'),
          content: const Text('출석이 완료되었습니다.'),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }
}

extension on PostgrestResponse {
  get error => null;
}

Future<String> checkPermission() async {
  final isLocationEnabled = await Geolocator.isLocationServiceEnabled();

  if (!isLocationEnabled) {
    return '위치 서비스를 활성화해주세요.';
  }

  LocationPermission checkedPermission = await Geolocator.checkPermission();

  if (checkedPermission == LocationPermission.denied) {
    checkedPermission = await Geolocator.requestPermission();
    if (checkedPermission == LocationPermission.denied) {
      return '위치 권한을 허가해주세요.';
    }
  }

  if (checkedPermission == LocationPermission.deniedForever) {
    return '앱의 위치 권한을 설정에서 허가해주세요.';
  }

  return '위치 권한이 허가 되었습니다.';
}
