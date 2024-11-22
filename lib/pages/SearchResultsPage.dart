import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroessaber/pages/moredetailpage.dart';

const Color burgundy = Color(0xFF570514);

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
                              'assets/player_img.png', // 선수 이미지
                              width: 180,
                              height: 180,
                            ),
                            const SizedBox(width: 150),
                            Image.asset(
                              'assets/kiwoom_logo.png', // 우측 로고 이미지
                              height: 80,
                              width: 220,
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

  // 5x5 표
  Widget _build5x5Table() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Container(
        width: 190,
        height: 190, // 높이 절반으로 줄임
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: burgundy, width: 1),
        ),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(1),
            4: FlexColumnWidth(1),
          },
          border: TableBorder.all(color: burgundy, width: 0.5),
          children: [
            for (int i = 0; i < 5; i++)
              TableRow(
                children: List.generate(
                  5,
                  (j) => Container(
                    height: 38, // 각 셀의 높이를 절반으로 줄임
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '값 1', // 위 값
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 7, // 폰트 크기 절반으로 줄임
                            color: burgundy,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2.5), // 위아래 값 간 간격 절반으로 줄임
                        Text(
                          '값 2', // 아래 값
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 6, // 폰트 크기 절반으로 줄임
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
      ),
    );
  }

  // 표 두 개를 나란히 배치
  Widget _buildSideBySideTables(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 첫 번째 표
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: _build5x5Table(),
                ),
              ),
              // 두 번째 표
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: _build5x5Table(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}