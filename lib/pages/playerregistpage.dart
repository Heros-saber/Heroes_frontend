import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:heroessaber/pages/battersearchresultspage.dart';
import 'package:heroessaber/pages/pitchersearchresultspage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const Color burgundy = Color(0xFF570514);

class PlayerRegistPage extends StatefulWidget {

  const PlayerRegistPage({super.key});

  @override
  _PlayerRegistPage createState() => _PlayerRegistPage();
}

class _PlayerRegistPage extends State<PlayerRegistPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // 상단 바
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 로고
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/mainpage');
                    },
                    child: Image.asset(
                      'assets/logo.png', // 로고 이미지 파일 경로
                      height: 50,
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    child: TextField(
                      onSubmitted: (value) async {
                        final playerType = await fetchPlayerType(value);

                        if (playerType == 'batter') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BatterSearchResultsPage(query: value),
                            ),
                          );
                        } else if (playerType == 'pitcher') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PitcherSearchResultsPage(query: value),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('해당 선수를 찾을 수 없습니다.')),
                          );
                        }
                      },
                      decoration: InputDecoration(
                        hintText: '선수 이름을 검색하세요',
                        prefixIcon: const Icon(Icons.search, color: burgundy),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: burgundy),
                        ),
                        contentPadding: const EdgeInsets.all(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 구분선
            const Divider(  
              color: burgundy,
              thickness: 1,
            ),
            // 나머지 콘텐츠
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    // NOTICE Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: burgundy.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: burgundy, width: 1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'NOTICE',
                              style: GoogleFonts.beVietnamPro(
                                fontWeight: FontWeight.bold,
                                color: burgundy,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              '현재 동명이인 선수에 대한 자동 크롤링 선수 등록은 지원하지 않습니다.\n\n'
                              '히어로즈 세이버는 키움에 최적화 되어 제작되어 타팀 선수일 경우 팀 로고, 선수 이미지 등이 출력되지 않을 수 있습니다.\n\n'
                              '이름을 타자, 투수에 맞게 입력하지 않으면 등록에 실패할 수 있습니다.',
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 80),
                    // Player Registration Section
                    _buildRegistrationInput('등록하고 싶은 타자 이름', '선수 이름을 입력하세요', true),
                    const SizedBox(height: 40),
                    _buildRegistrationInput('등록하고 싶은 투수 이름', '선수 이름을 입력하세요', false),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> fetchPlayerType(String playerName) async {
    const urlBase = 'http://localhost:8080/player/type/'; // API 엔드포인트
    try {
      final response = await http.get(Uri.parse('$urlBase$playerName'));

      if (response.statusCode == 200) {
        return response.body; // 'batter' 또는 'pitcher' 반환
      } else {
        throw Exception('Failed to fetch player type');
      }
    } catch (e) {
      print('Error fetching player type: $e');
      return '';
    }
  }

  Widget _buildRegistrationInput(String label, String hintText, bool isBatter) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
        const SizedBox(width: 400),
        // 레이블
        SizedBox(
          width: 250, // 레이블의 고정된 너비
          child: Text(
            label,
            style: GoogleFonts.beVietnamPro(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: burgundy,
            ),
          ),
        ),
        const SizedBox(width: 20), // 레이블과 검색창 사이의 간격
        // 검색창
        SizedBox(
          width: 350, // 검색창의 너비 제한
          child: TextField(
            onSubmitted: (value) {
              _registerPlayer(value, isBatter); // 타자 또는 투수 등록 API 호출
            },
            decoration: InputDecoration(
              hintText: hintText,
              prefixIcon: const Icon(Icons.search, color: burgundy),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: burgundy),
              ),
              contentPadding: const EdgeInsets.all(8),
            ),
          ),
        ),
      ],
      ),
    );
  }

  Future<void> _registerPlayer(String name, bool isBatter) async {
    final url = isBatter
        ? 'http://localhost:8080/crawling/batter/$name'
        : 'http://localhost:8080/crawling/pitcher/$name';
    print('Requesting URL: $url'); // 요청 URL 출력
    try {
      final response = await http.post(Uri.parse(url));
      print('Response Status Code: ${response.statusCode}'); // 상태 코드 출력
      print('Response Body: ${response.body}'); // 응답 본문 출력
      if (response.statusCode == 200) {
        _showDialog('성공', '등록이 성공적으로 완료되었습니다.', name, true);
      } else {
        _showDialog('실패', '등록에 실패했습니다. 다시 시도해주세요.', name, false);
      }
    } catch (e) {
      print('Error: $e'); // 에러 메시지 출력
      _showDialog('오류', '네트워크 오류가 발생했습니다. 다시 시도해주세요.', name, false);
    }
  }

  void _showDialog(String title, String message, String playerName, bool isSuccess) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: GoogleFonts.beVietnamPro(fontSize: 18, fontWeight: FontWeight.bold, color: burgundy)),
          content: Text(message, style: GoogleFonts.beVietnamPro(fontSize: 16, color: Colors.black)),
          actions: [
            TextButton(
              onPressed: () async {
              if (isSuccess) {
                final playerType = await fetchPlayerType(playerName);

                if (playerType == 'batter') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BatterSearchResultsPage(query: playerName),
                    ),
                  );
                } else if (playerType == 'pitcher') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PitcherSearchResultsPage(query: playerName),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('해당 선수를 찾을 수 없습니다.')),
                  );
                }
              } else {
                Navigator.of(context).pop();
              }
            },
              child: Text('확인', style: GoogleFonts.beVietnamPro(color: burgundy, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }
  
}