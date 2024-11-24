import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroessaber/pages/battersearchresultspage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const Color burgundy = Color(0xFF570514);
const Color coldColor = Color(0xFF90CAF9); // 차가운 색 (파란색 계열)
const Color hotColor = Color(0xFFEF5350); // 뜨거운 색 (빨간색 계열)

class BatterDetailPage extends StatefulWidget {
  final String query;

  const BatterDetailPage({super.key, required this.query});

  @override
  _BatterDetailPage createState() => _BatterDetailPage();
}

class _BatterDetailPage extends State<BatterDetailPage> {
  Map<String, dynamic>? playerInfo;
  List<dynamic>? stats;
  List<dynamic>? zones;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchPlayerData(widget.query);
  }

  Future<void> fetchPlayerData(String name) async {
    final url = 'http://localhost:8080/player/batter/$name/detail'; // API 엔드포인트
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          playerInfo = data['playerInfo'];
          stats = data['stats'];
          zones = _organizeOpsByCircumstance(data['groupedZones']);
        });
      } else {
        throw Exception('Failed to load player data');
      }
    } catch (e) {
      print('Error fetching player data: $e');
    }
  }

  List<Map<String, dynamic>> _organizeOpsByCircumstance(Map<String, dynamic> groupedZones) {
  List<Map<String, dynamic>> opsTables = [];
  groupedZones.forEach((circumstance, entries) {
    final opsEntry = entries.firstWhere((item) => item['tag'] == 'ops', orElse: () => null);
    if (opsEntry != null) {
      opsTables.add({
        'circumstance': circumstance,
        'opsData': opsEntry,
      });
    }
  });
  return opsTables;
}

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
                      onSubmitted: (value) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BatterSearchResultsPage(query: value),
                          ),
                        );
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
                        '이름: ${playerInfo?['playerName'] ?? 'N/A'}\n'
                        '생년월일: ${playerInfo?['playerBorn'] ?? 'N/A'}\n'
                        '데뷔: ${playerInfo?['playerDraft'] ?? 'N/A'}\n'
                        '포지션: ${playerInfo?['playerPos'] ?? 'N/A'}',
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
                // 구분선
                Container(
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
                ),
                const SizedBox(height: 50), // 상단과 상세 분석 사이 여백
                // 상세 분석 섹션
                _buildSideBySideTables(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

Widget _buildSideBySideTables(BuildContext context) {
  if (zones == null || zones!.isEmpty) {
    return Center(
      child: Text(
        'No data available',
        style: GoogleFonts.beVietnamPro(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  // 그룹화하여 테이블을 두 개씩 배치
  List<Widget> rows = [];
  for (int i = 0; i < zones!.length; i += 2) {
    rows.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 첫 번째 테이블
          if (i < zones!.length)
            _buildTableWithHeader(zones![i]['circumstance'], zones![i]['opsData']),
          const SizedBox(width: 50), // 테이블 간 간격
          // 두 번째 테이블
          if (i + 1 < zones!.length)
            _buildTableWithHeader(zones![i + 1]['circumstance'], zones![i + 1]['opsData']),
        ],
      ),
    );
    rows.add(const SizedBox(height: 50)); // 행 간 간격
  }

  return Column(
    children: rows,
  );
}

Widget _buildTableWithHeader(String title, Map<String, dynamic> opsData) {
  return Column(
    children: [
      Text(
        title,
        style: GoogleFonts.beVietnamPro(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      const SizedBox(height: 10),
      _buildDynamic5x5TableFromOps(opsData),
    ],
  );
}

Widget _buildDynamic5x5TableFromOps(Map<String, dynamic> opsData) {
  const double tableSize = 380; // Table total size
  const double cellSize = tableSize / 5; // Each cell size

  // Preprocess data into a 5x5 list
  List<List<double?>> tableData = List.generate(
    5,
    (row) => List.generate(
      5,
      (col) {
        int zoneIndex = (row * 5) + col + 1;
        return opsData['zone$zoneIndex']?.toDouble();
      },
    ),
  );

  Color _getBackgroundColor(double? value) {
    if (value == null || value == 0) return Colors.white;
    if (value < 0.7) {
      return coldColor; // Cold Zone
    } else {
      double intensity = (value - 0.7) / (1.0 - 0.7); // Normalize intensity
      return Color.lerp(
        const Color.fromARGB(255, 247, 192, 192), // Base warm color
        hotColor, // Hot color
        intensity,
      )!;
    }
  }

  // Build the table UI
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
      border: TableBorder.all(color: burgundy, width: 0.5),
      children: tableData.map(
        (rowData) {
          return TableRow(
            children: rowData.map(
              (value) {
                return Container(
                  width: cellSize,
                  height: cellSize,
                  alignment: Alignment.center,
                  color: _getBackgroundColor(value),
                  child: Text(
                    value?.toStringAsFixed(3) ?? '',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ).toList(),
          );
        },
      ).toList(),
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
