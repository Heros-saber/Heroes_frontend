import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroessaber/pages/moredetailpage.dart';

const Color burgundy = Color(0xFF570514);
const Color coldColor = Color(0xFF90CAF9); // 차가운 색 (파란색 계열)
const Color hotColor = Color(0xFFEF5350); // 뜨거운 색 (빨간색 계열)

class SearchResultsPage extends StatelessWidget {
  final String query;

  const SearchResultsPage({super.key, required this.query});

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
                  // 상세 분석 섹션
                  _buildSectionTitle('상세 분석'),
                  _buildDetailedAnalysisTable(),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(right: 300),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          // 새로운 페이지로 이동
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const MoreDetailsPage()),
                          );
                        },
                        child: Text(
                          '더보기 >>',
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            decoration: TextDecoration.underline, // 밑줄 추가
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  _buildSectionTitle('추가 데이터'),
                  _buildSideBySideTables(context),
                ],
              ),
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

  // 상세 분석 테이블
  Widget _buildDetailedAnalysisTable() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
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
            5: FlexColumnWidth(1),
            6: FlexColumnWidth(1),
            7: FlexColumnWidth(1),
            8: FlexColumnWidth(1),
            9: FlexColumnWidth(1),
            10: FlexColumnWidth(1),
            11: FlexColumnWidth(1),
            12: FlexColumnWidth(1),
          },
          children: [
            _buildTableHeader([
              'Year',
              'AVG',
              'OBP',
              'SLG',
              'OPS',
              'WRC+',
              'PA',
              'AB',
              'H',
              '2B',
              '3B',
              'HR',
              'RBI'
            ]),
            for (int i = 0; i < 10; i++)
              _buildTableRow(List.generate(13, (index) => '2015')),
          ],
        ),
      ),
    );
  }

  // 테이블 헤더 생성
  TableRow _buildTableHeader(List<String> headers) {
    return TableRow(
      decoration: BoxDecoration(
        color: burgundy.withOpacity(0.1), // 헤더 배경색 설정
      ),
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
        const SizedBox(width: 20),
        _buildDynamic5x5Table(),
      ],
    );
  }

  // 그림자 구분선
  Widget _buildShadowDivider() {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.4),
        boxShadow: [
          BoxShadow(
            color: burgundy.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
    );
  }
}
