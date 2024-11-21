import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroessaber/pages/searchresultspage.dart';

void main() {
  runApp(MyApp());
}

const Color burgundy = Color(0xFF570514);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/mainpage',
      routes: {
        '/mainpage': (context) => MainPage(),
        '/searchresults': (context) => SearchResultsPage(query: 'Default Player'),
      },
      theme: ThemeData(
        primaryColor: burgundy,
        textTheme: GoogleFonts.beVietnamProTextTheme(),
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
    );
  }
}

class MainPage extends StatelessWidget {
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
                  Image.asset(
                    'assets/logo.png',
                    height: 50,
                  ),
                  SizedBox(
                    width: 300,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: '선수 이름을 검색하세요',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: burgundy),
                        ),
                        contentPadding: const EdgeInsets.all(8),
                        prefixIcon: IconButton(
                          icon: const Icon(Icons.search, color: burgundy),
                            onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/searchresults',
                            );
                          },
                        ),
                      ),
                      onSubmitted: (_) {
                        Navigator.pushNamed(context, '/searchresults');
                      },
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
                    const SizedBox(height: 50),
                    Image.asset(
                      'assets/wallpaper.png',
                      fit: BoxFit.cover,
                      width: 948,
                      height: 524,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildStatBox('순위', '6th'),
                        const SizedBox(width: 30),
                        _buildStatBox('승', '28'),
                        const SizedBox(width: 30),
                        _buildStatBox('패', '26'),
                      ],
                    ),
                    const SizedBox(height: 30),
                    _buildSectionTitle('타자 순위'),
                    _buildHitterRankingTable(),
                    const SizedBox(height: 30),
                    _buildSectionTitle('투수 순위'),
                    _buildPitcherRankingTable(),
                    const SizedBox(height: 30),
                    _buildSectionTitle('다음 경기'),
                    _buildNextMatchBox(),
                    const SizedBox(height: 30),
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
        width: 960,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: burgundy, width: 1),
        ),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(1),
            4: FlexColumnWidth(1),
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

  // 투수 순위 테이블
  Widget _buildPitcherRankingTable() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Container(
        width: 960,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: burgundy, width: 1),
        ),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(1),
            4: FlexColumnWidth(1),
          },
          children: [
            _buildTableHeader(['Name', 'ERA', 'W', 'L', 'SV']),
            _buildTableRow(['Kim Ha-seong', '2.73', '28', '7', '0']),
            _buildTableRow(['Lee Jung-hoo', '3.20', '12', '10', '0']),
            _buildTableRow(['Park Byung-ho', '2.67', '39', '9', '1']),
            _buildTableRow(['Choi Hyung-woo', '3.83', '27', '8', '0']),
            _buildTableRow(['Kim Jae-hwan', '2.41', '34', '9', '1']),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildSocialMediaButton(Icons.language, '@kiwoom_heroes'),
          const SizedBox(width: 30),
          _buildSocialMediaButton(Icons.camera_alt, '@kiwoom_heroes'),
          const SizedBox(width: 30),
          _buildSocialMediaButton(Icons.play_circle_fill, 'Kiwoom Heroes'),
        ],
      ),
    );
  }

  // 소셜 미디어 버튼
  Widget _buildSocialMediaButton(IconData icon, String text) {
    return Container(
      width: 301,
      height: 58,
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