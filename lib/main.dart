import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

const Color burgundy = Color(0xFF570514);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: burgundy,
        textTheme: GoogleFonts.beVietnamProTextTheme(), // 전체 텍스트에 Be Vietnam Pro 적용
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: burgundy),
          ),
          hintStyle: const TextStyle(color: burgundy),
        ),
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // 상단 바
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                        hintText: '선수 이름을 검색하세요',
                        prefixIcon: const Icon(Icons.search, color: burgundy),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.white),
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
              height: 31,
            ),
            // 나머지 콘텐츠
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // 여백 추가
                    const SizedBox(height: 50),
                    // 달력 이미지
                    Image.asset(
                      'assets/wallpaper.png', // 이미지 경로
                      fit: BoxFit.cover,
                      width: 948,
                      height: 524,
                    ),
                    // 하단 여백
                    const SizedBox(height: 20),
                    Row (
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 첫 번째 박스
                        _buildStatBox('순위', '6th'),
                        const SizedBox(width: 30),
                        // 두 번째 박스
                        _buildStatBox('승', '28'),
                        const SizedBox(width: 30),
                        // 세 번째 박스
                        _buildStatBox('패', '26'),
                      ],
                    ),
                    const SizedBox(height: 30),
                    // 달력 섹션
                    _buildCalendar(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 박스를 생성하는 위젯
  Widget _buildStatBox(String title, String value) {
    return Container(
      width: 298,
      height: 112,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: burgundy, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: GoogleFonts.beVietnamPro(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.beVietnamPro(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // 달력 생성
  Widget _buildCalendar() {
    return Container(
      width: 943, // 너비
      height: 626, // 높이
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: burgundy, width: 1),
      ),
      child: Column(
        children: [
          // 달력 헤더
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: burgundy),
                onPressed: () {},
              ),
              Text(
                "2024년 7월",
                style: GoogleFonts.beVietnamPro(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: burgundy,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward, color: burgundy),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 10),
          // 요일 헤더
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("일", style: TextStyle(color: Colors.red)),
              Text("월"),
              Text("화"),
              Text("수"),
              Text("목"),
              Text("금"),
              Text("토", style: TextStyle(color: Colors.blue)),
            ],
          ),
          const SizedBox(height: 10),
          // 날짜 그리드
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              itemCount: 31, // 날짜 수
              itemBuilder: (context, index) {
                return Container(
                  alignment: Alignment.center,
                  child: Text(
                    '${index + 1}',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 16,
                      color: burgundy,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}