import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color burgundy = Color(0xFF570514);

class MoreDetailsPage extends StatelessWidget {
  const MoreDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView( // 전체 화면 스크롤 가능
        child: Column(
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
            Column(
              children: [
                // 상단 배경과 선수 정보
                Container(
                  height: 450, // 상단 배경의 높이
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [burgundy, Colors.white],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 50), // 이미지와 내용을 아래로 이동
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                _buildShadowDivider(),
                const SizedBox(height: 50), // 상단과 상세 분석 사이 여백
                _buildSectionTitle('추가 데이터'),
                _buildSideBySideTables(context),
                const SizedBox(height: 50), // 테이블 사이 여백
                _buildSideBySideTables(context), // 두 번째 테이블 추가
                const SizedBox(height: 50), // 테이블 사이 여백
                _buildSideBySideTables(context), // 세 번째 테이블 추가
              ],
            ),
          ],
        ),
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

  // 표 두 개를 나란히 배치
  Widget _buildSideBySideTables(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 첫 번째 표
          SizedBox(
            width: 380,
            height: 380,
            child: _build5x5Table(),
          ),
          const SizedBox(width: 180), // 표 사이 간격
          // 두 번째 표
          SizedBox(
            width: 380,
            height: 380,
            child: _build5x5Table(),
          ),
        ],
      ),
    );
  }

  // 5x5 표
  Widget _build5x5Table() {
    const double tableSize = 380;
    const double cellSize = tableSize / 5;

    return Container(
      width: tableSize,
      height: tableSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: burgundy, width: 1),
      ),
      child: Table(
        columnWidths: const {
          0: FixedColumnWidth(cellSize),
          1: FixedColumnWidth(cellSize),
          2: FixedColumnWidth(cellSize),
          3: FixedColumnWidth(cellSize),
          4: FixedColumnWidth(cellSize),
        },
        border: TableBorder.all(color: burgundy, width: 0.5),
        children: [
          for (int i = 0; i < 5; i++)
            TableRow(
              children: List.generate(
                5,
                (j) => Container(
                  width: cellSize,
                  height: cellSize,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '값 1',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 14,
                          color: burgundy,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2.5),
                      Text(
                        '값 2',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // 구분선
  Widget _buildShadowDivider() {
    return Container(
      // margin: const EdgeInsets.symmetric(vertical: 10), // 구분선 위아래 여백
      height: 1, // 구분선 높이
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.4), // 구분선의 기본 색상
        boxShadow: [
          BoxShadow(
            color: burgundy.withOpacity(0.3), // 그림자 색상
            offset: const Offset(0, 3), // 그림자 위치 (아래쪽으로 3px 이동)
            blurRadius: 6, // 그림자 흐림 효과
            spreadRadius: 0, // 그림자의 확산 정도
          ),
        ],
      ),
    );
  }
}
