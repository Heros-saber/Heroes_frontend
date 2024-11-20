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
                    const SizedBox(height: 30),
                    // 타자 순위 테이블
                    _buildSectionTitle('타자 순위'),
                    _buildHitterRankingTable(),
                    const SizedBox(height: 30),
                    // 투수 순위 테이블
                    _buildSectionTitle('투수 순위'),
                    _buildPitcherRankingTable(),
                    const SizedBox(height: 30),
                    // 다음 경기 섹션
                    _buildSectionTitle('다음 경기'),
                    _buildNextMatchBox(),
                    const SizedBox(height: 30),
                    // 소셜 미디어 섹션
                    _buildSectionTitle('Social Media'),
                    _buildSocialMediaBox(),
                    const SizedBox(height: 30),
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
          Container(
            decoration: BoxDecoration(
              // border: Border(
              //   bottom: BorderSide(color: burgundy, width: 0.5),
              // ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Expanded(child: Center(child: Text("일", style: TextStyle(color: Colors.red)))),
                Expanded(child: Center(child: Text("월"))),
                Expanded(child: Center(child: Text("화"))),
                Expanded(child: Center(child: Text("수"))),
                Expanded(child: Center(child: Text("목"))),
                Expanded(child: Center(child: Text("금"))),
                Expanded(child: Center(child: Text("토", style: TextStyle(color: Colors.blue)))),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // 날짜 그리드
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                crossAxisSpacing: 0, // 셀 간격 0
                mainAxisSpacing: 0, // 셀 간격 0
              ),
              itemCount: 31, // 날짜 수
              itemBuilder: (context, index) {
                return Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: burgundy, width: 0.5), // 날짜 셀 테두리
                  ),
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

  // 섹션 타이틀
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 300), 
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: GoogleFonts.beVietnamPro(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

   // 타자 순위 테이블
  Widget _buildHitterRankingTable() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Container(
        width: 960, // 가로 길이 설정
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), // radius 추가
          border: Border.all(color: burgundy, width: 1),
        ),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(2), // Name
            1: FlexColumnWidth(1), // AVG
            2: FlexColumnWidth(1), // HR
            3: FlexColumnWidth(1), // RBI
            4: FlexColumnWidth(1), // OPS
          },
          children: [
            _buildTableHeader(['Name', 'AVG', 'HR', 'RBI', 'OPS']),
            _buildTableRow(['Kim Ha-seong', '0.273', '29', '77', '0.921']),
            _buildTableRow(['Lee Jung-hoo', '0.309', '13', '46', '0.911']),
            _buildTableRow(['Park Byung-ho', '0.267', '39', '103', '0.876']),
            _buildTableRow(['Choi Hyung-woo', '0.283', '27', '83', '0.873']),
            _buildTableRow(['Kim Jae-hwan', '0.241', '34', '91', '0.835']),
          ],
        ),
      ),
    );
  }

  // 타자 순위 테이블
Widget _buildHitterRankingTable() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 40),
    child: Container(
      width: 960, // 가로 길이 설정
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12), // 전체 테두리 둥글기
        border: Border.all(color: burgundy, width: 1),
      ),
      child: Column(
        children: [
          // 테이블 헤더
          Container(
            decoration: BoxDecoration(
              color: burgundy.withOpacity(0.1), // 헤더 배경 색
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12), // 좌측 상단 둥글기
                topRight: Radius.circular(12), // 우측 상단 둥글기
              ),
            ),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(2), // Name
                1: FlexColumnWidth(1), // AVG
                2: FlexColumnWidth(1), // HR
                3: FlexColumnWidth(1), // RBI
                4: FlexColumnWidth(1), // OPS
              },
              children: [
                _buildTableHeader(['Name', 'AVG', 'HR', 'RBI', 'OPS']),
              ],
            ),
          ),
          // 테이블 바디
          Table(
            columnWidths: const {
              0: FlexColumnWidth(2), // Name
              1: FlexColumnWidth(1), // AVG
              2: FlexColumnWidth(1), // HR
              3: FlexColumnWidth(1), // RBI
              4: FlexColumnWidth(1), // OPS
            },
            children: [
              _buildTableRow(['Kim Ha-seong', '0.273', '29', '77', '0.921']),
              _buildTableRow(['Lee Jung-hoo', '0.309', '13', '46', '0.911']),
              _buildTableRow(['Park Byung-ho', '0.267', '39', '103', '0.876']),
              _buildTableRow(['Choi Hyung-woo', '0.283', '27', '83', '0.873']),
              _buildTableRow(['Kim Jae-hwan', '0.241', '34', '91', '0.835']),
            ],
          ),
        ],
      ),
    ),
  );
}

  // 테이블 헤더 생성
TableRow _buildTableHeader(List<String> headers) {
  return TableRow(
    children: headers
        .map(
          (header) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              header,
              style: GoogleFonts.beVietnamPro(
                fontWeight: FontWeight.bold,
                color: burgundy,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        )
        .toList(),
  );
}

// 테이블 행 생성
TableRow _buildTableRow(List<String> cells) {
  return TableRow(
    children: cells
        .map(
          (cell) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              cell,
              style: GoogleFonts.beVietnamPro(
                fontSize: 14,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        )
        .toList(),
  );
}

    // 다음 경기 박스
  Widget _buildNextMatchBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: 960,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: burgundy, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'LG Twins vs Kiwoom Heroes',
              style: GoogleFonts.beVietnamPro(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'September 21, 2022 6:30 PM KST',
              style: GoogleFonts.beVietnamPro(
                fontSize: 14,
                color: burgundy,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 소셜 미디어 박스
  Widget _buildSocialMediaBox() {
    return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
      children: [
        // 첫 번째 소셜 미디어 버튼
        _buildSocialMediaButton(Icons.language, '@kiwoom_heroes'),
        const SizedBox(width: 30), // 박스 간 간격
        // 두 번째 소셜 미디어 버튼
        _buildSocialMediaButton(Icons.camera_alt, '@kiwoom_heroes'),
        const SizedBox(width: 30), // 박스 간 간격
        // 세 번째 소셜 미디어 버튼
        _buildSocialMediaButton(Icons.play_circle_fill, 'Kiwoom Heroes'),
      ],
    ),
  );
  }

  // 소셜 미디어 버튼
  Widget _buildSocialMediaButton(IconData icon, String text) {
    return Container(
    width: 301, // 버튼 크기 조정
    height: 58, // 높이 설정
    padding: const EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: burgundy, width: 1),
    ),
    child: Row(
      children: [
        Icon(icon, color: burgundy, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.beVietnamPro(
              fontSize: 14,
              color: burgundy,
            ),
          ),
        ),
      ],
    ),
  );
  }
}