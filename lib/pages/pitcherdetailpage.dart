import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color burgundy = Color(0xFF570514);
const Color coldColor = Color(0xFF90CAF9); // 차가운 색 (파란색 계열)
const Color hotColor = Color(0xFFEF5350); // 뜨거운 색 (빨간색 계열)

class PitcherDetailsPage extends StatelessWidget {
  const PitcherDetailsPage({super.key});

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
                  InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/mainpage');
                  },
                  child: Image.asset(
                    'assets/logo.png', // 로고 이미지 파일 경로
                    height: 50,
                  ),
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

  // 5x5 표 (동적 색상 변경, 테두리 유지)
  Widget _buildDynamic5x5Table() {
    const double tableSize = 380; // 테이블 전체 크기
    const double cellSize = tableSize / 5; // 각 셀 크기

    // 더미 데이터
    final List<List<double>> data = [
      [0.208, 0.318, 0.389, 0.429, 0.338],
      [0.271, 0.360, 0.457, 0.500, 0.370],
      [0.250, 0.370, 0.358, 0.338, 0.318],
      [0.338, 0.360, 0.429, 0.389, 0.318],
      [0.208, 0.250, 0.271, 0.338, 0.308],
    ];

    // 배경색 계산 (핫-콜드 존)
    Color _getBackgroundColor(double value) {
      if (value < 0.35) {
        // Cold Zone (blue)
        return coldColor;
      } else {
        // Hot Zone (red) with intensity scaling for higher values
        double intensity = (value - 0.35) / (0.5 - 0.35); // Scale intensity for hot zone
        return Color.lerp(const Color.fromARGB(255, 247, 192, 192), hotColor, intensity)!;
      }
    }

    return Container(
      width: tableSize,
      height: tableSize,
      child: Table(
        columnWidths: const {
          0: FixedColumnWidth(cellSize),
          1: FixedColumnWidth(cellSize),
          2: FixedColumnWidth(cellSize),
          3: FixedColumnWidth(cellSize),
          4: FixedColumnWidth(cellSize),
        },
        border: TableBorder.all(color: burgundy, width: 0.5), // 각 셀의 테두리
        children: [
          for (int i = 0; i < 5; i++)
            TableRow(
              children: List.generate(
                5,
                (j) => Container(
                  width: cellSize, // 셀 크기 유지
                  height: cellSize,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _getBackgroundColor(data[i][j]), // 배경색만 변경
                  ),
                  child: Text(
                    data[i][j].toStringAsFixed(3), // 값 표시
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }


  // 표 두 개 나란히
  Widget _buildSideBySideTables(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDynamic5x5Table(),
        const SizedBox(width: 200),
        _buildDynamic5x5Table(),
      ],
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
