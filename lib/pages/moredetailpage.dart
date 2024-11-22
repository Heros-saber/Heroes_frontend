import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color burgundy = Color(0xFF570514);

class MoreDetailsPage extends StatelessWidget {
  const MoreDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Image.asset(
                  'assets/logo.png', // 로고 이미지 파일 경로
                  height: 50,
                ),
                // 검색창
                SizedBox(
                  width: 300,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
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
          // 검색 결과 콘텐츠
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // 상단 배경과 선수 정보
                  Container(
                    height: 450, // 상단 배경의 높이 증가
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [burgundy, Colors.white],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 100), // 이미지와 내용을 아래로 이동
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/kiwoom_logo_circle.png', // 좌측 로고 이미지  
                              height: 180,
                              width: 100,
                            ),
                            const SizedBox(width: 150),
                            Image.asset(
                              'assets/kiwoom_logo_circle.png', // 좌측 로고 이미지  
                              height: 150,
                              width: 150,
                            ),
                            const SizedBox(width: 250),
                            Image.asset(
                              'assets/player_img.png', // 선수 이미지
                              width: 250,
                              height: 250,
                            ),
                            const SizedBox(width: 200),
                            Image.asset(
                              'assets/kiwoom_logo.png', // 우측 로고 이미지
                              height: 200,
                              width: 200,
                            ),
                          ],
                        ),
                        const SizedBox(height: 30), // 선수 정보 아래로 이동
                        // 선수 상세 정보
                        Text(
                          '이름: 송성문\n생년월일: 1996.08.29\n데뷔: 15 넥센 2차 5라운드\n포지션: 3B',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}