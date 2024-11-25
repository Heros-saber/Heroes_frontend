import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroessaber/pages/battersearchresultspage.dart';
import 'package:heroessaber/pages/pitcherdetailpage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const Color burgundy = Color(0xFF570514);
const Color coldColor = Color(0xFF90CAF9); // 차가운 색 (파란색 계열)
const Color hotColor = Color(0xFFEF5350); // 뜨거운 색 (빨간색 계열)

class PitcherSearchResultsPage extends StatefulWidget {
  final String query;

  const PitcherSearchResultsPage({super.key, required this.query});

  @override
  _PitcherSearchResultsPageState createState() => _PitcherSearchResultsPageState();
}

class _PitcherSearchResultsPageState extends State<PitcherSearchResultsPage> {
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
    final url = 'http://localhost:8080/player/pitcher/$name'; // API 엔드포인트
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          playerInfo = data['playerInfo'];
          stats = data['stats'];
          zones = data['zone'] ?? [];
        });
      } else {
        throw Exception('Failed to load player data');
      }
    } catch (e) {
      print('Error fetching player data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final query = ModalRoute.of(context)?.settings.arguments as String? ?? 'Default Player';
    
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
                  _buildShadowDivider(),
                  const SizedBox(height: 50), // 상단과 상세 분석 사이 여백
                  Padding(
                    padding: const EdgeInsets.only(right: 300),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          // 새로운 페이지로 이동
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const PitcherDetailsPage()),
                          );
                        },
                        child: Text(
                          '더보기 >>',
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // 상세 분석 섹션
                  _buildSectionTitle('상세 분석'),
                  _buildDetailedAnalysisTable(),
                  const SizedBox(height: 10),
                  const SizedBox(height: 50),
                  _buildSideBySideTables(context),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
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
        width: 1200,
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
            5: FlexColumnWidth(1),
            6: FlexColumnWidth(1),
            7: FlexColumnWidth(1),
            8: FlexColumnWidth(1),
            9: FlexColumnWidth(1),
            10: FlexColumnWidth(1),
            11: FlexColumnWidth(1),
            12: FlexColumnWidth(1),
            13: FlexColumnWidth(1),
            14: FlexColumnWidth(1),
            15: FlexColumnWidth(1),
            16: FlexColumnWidth(1),
            17: FlexColumnWidth(1),
          },
          children: [
            _buildTableHeader([
              'Year',
              'G',
              'WIN',
              'LOSE',
              'SAVE',
              'HOLD',
              'IP',
              'ER',
              'ERA',
              'TBF',
              'H',
              '2B',
              '3B',
              'HR',
              'BB',
              'SO',
              'WHIP',
              'WAR',
            ]),
             for (var stat in stats!)
              _buildTableRow([
                stat['year'].toString(),
                stat['games'].toString(),
                stat['win'].toString(),
                stat['lose'].toString(),
                stat['save'].toString(),
                stat['hold'].toString(),
                stat['ip'].toString(),
                stat['er'].toString(),
                stat['era'].toString(),
                stat['tbf'].toString(),
                stat['h'].toString(),
                stat['twoB'].toString(),
                stat['threeB'].toString(),
                stat['hr'].toString(),
                stat['bb'].toString(),
                stat['so'].toString(),
                stat['whip'].toString(),
                stat['war'].toString(),
              ]),
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
  Widget _buildDynamic5x5Table(String tag) {
    const double tableSize = 380; // 테이블 전체 크기
    const double cellSize = tableSize / 5; // 각 셀 크기

    final zoneData = zones?.firstWhere((zone) 
    => zone['tag'] == tag, orElse: () => null);

    if (zoneData == null) {
      return Center(
        child: Text(
          '0',
          style: GoogleFonts.beVietnamPro(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
      );
    }

    // 데이터 추출 (존 번호 1~25)
    List<List<double?>> tableData = [];
    for (int row = 0; row < 5; row++) {
      List<double?> rowData = [];
      for (int col = 0; col < 5; col++) {
        int zoneIndex = (row * 5) + col + 1;
        rowData.add(zoneData['zone$zoneIndex']?.toDouble());
      }
      tableData.add(rowData);
    }

    // 배경색 계산 (핫-콜드 존)
    Color? _getBackgroundColor(double? value) {
      if (value == null) return Colors.white;
      if (tag == '구사율') {
        // 타율 기준
        if (value < 3.2) {
          return coldColor; // Cold Zone
        } else {
          double intensity = (value - 3.2) / (8 - 3.2);
          return Color.lerp(
              const Color.fromARGB(255, 247, 192, 192), hotColor, intensity)!;
        }
      } else if (tag == '타율') {
        // OPS 기준
        if (value < 0.25) {
          return coldColor;
        } else {
          double intensity = (value - 0.25) / (1.0 - 0.25);
          return Color.lerp(
              const Color.fromARGB(255, 247, 192, 192), hotColor, intensity)!;
        }
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
                    color: _getBackgroundColor(tableData[i][j]), // 배경색만 변경
                  ),
                  child: Text(
                    tableData[i][j]?.toStringAsFixed(3) ?? '', // 값 표시
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
        // 첫 번째 표 및 섹션 타이틀
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10), // 제목과 표 간격 조정
              child: Text(
                '구사율', // 첫 번째 표 제목
                style: GoogleFonts.beVietnamPro(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            _buildDynamic5x5Table('구사율'),
          ],
        ),
        const SizedBox(width: 250), // 표 사이 간격
        // 두 번째 표 및 섹션 타이틀
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10), // 제목과 표 간격 조정
              child: Text(
                '피안타율', // 두 번째 표 제목
                style: GoogleFonts.beVietnamPro(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            _buildDynamic5x5Table('타율'),
          ],
        ),
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
