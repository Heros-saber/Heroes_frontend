import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroessaber/pages/battersearchresultspage.dart';
import 'package:heroessaber/pages/pitchersearchresultspage.dart';
import 'package:heroessaber/pages/playerregistpage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

const Color burgundy = Color(0xFF570514);

class GameResult {
  final DateTime date;
  final int kiwoomScore;
  final int opponentScore;
  final bool? win;

  GameResult({required this.date, required this.kiwoomScore, required this.opponentScore, this.win});

  factory GameResult.fromJson(Map<String, dynamic> json) {
    return GameResult(
      date: DateTime.parse(json['date']),
      kiwoomScore: json['kiwoomScore'],
      opponentScore: json['opponentScore'],
      win: json['win'],
    );
  }
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/mainpage',
      routes: {
        '/mainpage': (context) => MainPage(),
        '/registerPlayer': (context) => PlayerRegistPage(),
      },
      home: MainPage(),
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

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}


class _MainPageState extends State<MainPage> {
  int rank = 0;
  int win = 0;
  int lose = 0;
  String nextGame = '다음 경기가 존재하지 않습니다.';
  Map<DateTime, List<GameResult>> gameResults = {};
  DateTime focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchMonthlyGames(DateTime.now().year, DateTime.now().month);
  }

  Future<void> fetchData() async {
    const url = 'http://localhost:8080/main'; // API 엔드포인트
    try {
      final response = await http.get(Uri.parse(url));
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          rank = data['rank'] ?? 0;
          win = data['win'] ?? 0;
          lose = data['lose'] ?? 0;
          nextGame = data['nextGame'] ?? '다음 경기가 존재하지 않습니다';
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

Future<void> fetchMonthlyGames(int year, int month) async {
  final url = 'http://localhost:8080/main/match?year=$year&month=$month';
  try {
    final response = await http.get(Uri.parse(url));
    print('Fetching games for $year-$month: Status Code: ${response.statusCode}');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final results = data.map((game) => GameResult.fromJson(game)).toList();
      print('Fetched Results: $results'); // 디버깅 로그

      setState(() {
        gameResults = groupByDate(results);
        print('Grouped Results: $gameResults'); // 디버깅 로그
      });
    } else {
      throw Exception('Failed to load monthly games');
    }
  } catch (e) {
    print('Error fetching monthly games: $e');
  }
}

Map<DateTime, List<GameResult>> groupByDate(List<GameResult> results) {
  final grouped = <DateTime, List<GameResult>>{};
  for (var result in results) {
    // 날짜만 사용 (시간 제거)
    final day = DateTime(result.date.year, result.date.month, result.date.day);
    if (!grouped.containsKey(day)) {
      grouped[day] = [];
    }
    grouped[day]!.add(result);
    print('Adding result for $day: $result'); // 디버깅 로그
  }
  return grouped;
}


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
                children: [
                  // 로고
                  Image.asset(
                    'assets/logo.png',
                    height: 50,
                  ),
                  const SizedBox(width: 850),
                    ElevatedButton(
                    onPressed: () {
                      // 선수 등록 페이지 이동 로직 추가
                      Navigator.pushNamed(context, '/registerPlayer');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: burgundy, // 버튼 색상
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                    ),
                    child: Text(
                      '선수 등록',
                      style: GoogleFonts.beVietnamPro(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 50),
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
             // 구분선
            const Divider(  
              color: burgundy,
              thickness: 1,
            ),
            // 나머지 콘텐츠
            Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 45),
                  Image.asset(
                    'assets/wallpaper.png',
                    fit: BoxFit.cover,
                    width: 948,
                    height: 524,
                  ),
                  const SizedBox(height: 50),
                  Container(
                    width: 948,
                    height: 400,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: burgundy, width: 1),
                    ),
                    child: TableCalendar(
                      firstDay: DateTime.utc(2023, 1, 1),
                      lastDay: DateTime.utc(2024, 12, 31),
                      focusedDay: focusedDay,
                      onPageChanged: (newFocusedDay) {
                        setState(() {
                          focusedDay = newFocusedDay; // 포커스된 날짜 업데이트
                        });
                        fetchMonthlyGames(newFocusedDay.year, newFocusedDay.month); // 새로운 데이터 로드
                      },
                      calendarFormat: CalendarFormat.month,
                      eventLoader: (day) {
                        final truncatedDay = DateTime(day.year, day.month, day.day); // 날짜만 사용
                        final events = gameResults[truncatedDay] ?? []; // List<GameResult> 가져오기
                        print('Events for $truncatedDay: $events'); // 디버깅 로그
                        return events;
                      },
                      headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                        titleTextStyle: GoogleFonts.beVietnamPro(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: burgundy,
                        ),
                        leftChevronIcon: Icon(
                          Icons.chevron_left,
                          color: burgundy,
                          size: 24,
                        ),
                        rightChevronIcon: Icon(
                          Icons.chevron_right,
                          color: burgundy,
                          size: 24,
                        ),
                      ),
                      daysOfWeekStyle: DaysOfWeekStyle(
                        weekdayStyle: GoogleFonts.beVietnamPro(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        weekendStyle: GoogleFonts.beVietnamPro(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.red,
                        ),
                      ),
                      calendarStyle: CalendarStyle(
                        markersMaxCount: 0,
                        todayDecoration: BoxDecoration(
                          color: burgundy.withOpacity(1.0),
                          shape: BoxShape.circle,
                        ),
                        todayTextStyle: GoogleFonts.beVietnamPro(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        defaultTextStyle: GoogleFonts.beVietnamPro(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        weekendTextStyle: GoogleFonts.beVietnamPro(
                          fontSize: 14,
                          color: Colors.red,
                        ),
                        outsideDaysVisible: false,
                        cellMargin: const EdgeInsets.symmetric(vertical: 8), // 세로 간격 조정
                      ),
                      calendarBuilders: CalendarBuilders(
                        defaultBuilder: (context, day, focusedDay) {
                          // 날짜와 경기 결과를 Column으로 배치
                          final truncatedDay = DateTime(day.year, day.month, day.day);
                          final events = gameResults[truncatedDay] ?? []; // 해당 날짜의 경기 결과 가져오기

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${day.day}', // 날짜 텍스트
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4), // 날짜와 경기 결과 사이 간격
                              if (events.isNotEmpty)
                                ...events.map((game) {
                                  return Text(
                                    '${game.kiwoomScore}:${game.opponentScore} (${game.win == true ? "승" : "패"})', // 경기 결과 텍스트
                                    style: GoogleFonts.beVietnamPro(
                                      fontSize: 13,
                                      fontWeight: FontWeight.normal,
                                      color: burgundy,
                                    ),
                                  );
                                }).toList(),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildStatBox('순위', rank.toString()),
                        const SizedBox(width: 30),
                        _buildStatBox('승', win.toString()),
                        const SizedBox(width: 30),
                        _buildStatBox('패',  lose.toString()),
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
        child: Text(
          nextGame,
          style: GoogleFonts.beVietnamPro(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: nextGame == '다음 경기가 존재하지 않습니다' ? burgundy : Colors.black,
          ),
        ),
      ),
    );
  }

  // 섹션 타이틀
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 280, vertical: 20),
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
          },
          children: [
            _buildTableHeader(['Name', 'AVG', 'HR', 'RBI', 'OPS', 'WAR', 'WRC+']),
            _buildTableRow(['송성문', '0.340', '19', '104', '0.927', '6.13', '148.9']),
            _buildTableRow(['김혜성', '0.326', '11', '75', '0.841', '5.16', '124.1']),
            _buildTableRow(['이주형', '0.226', '19', '60', '0.754', '1.99', '103.6']),
            _buildTableRow(['최주환', '0.257', '13', '84', '0.715', '-0.03', '86.1']),
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
          },
          children: [
            _buildTableHeader(['Name', 'ERA', 'W', 'L', 'SV', 'WHIP', 'WAR']),
            _buildTableRow(['후라도', '3.36', '10', '8', '0', '1.14', '6.61']),
            _buildTableRow(['헤이수스', '3.68', '13', '11', '0', '1.25', '5.09']),
            _buildTableRow(['하영민', '4.37', '9', '8', '0', '1.5', '3.25']),
            _buildTableRow(['주승우', '4.35', '4', '6', '14', '1.32', '0.98']),
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

  // 소셜 미디어 박스
  Widget _buildSocialMediaBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildSocialMediaButton(Icons.language, 'kiwoom_heroes', 'https://heroesbaseball.co.kr/index.do'),
          const SizedBox(width: 30),
          _buildSocialMediaButton(Icons.camera_alt, '@kiwoom_heroes', 'https://www.instagram.com/heroesbaseballclub/'),
          const SizedBox(width: 30),
          _buildSocialMediaButton(Icons.play_circle_fill, 'Kiwoom Heroes', 'https://www.youtube.com/@heroesbaseballclub'),
        ],
      ),
    );
  }

  // 소셜 미디어 버튼
  Widget _buildSocialMediaButton(IconData icon, String text, String url) {
    return InkWell(
      onTap: () async {
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }
      },
      child: Container(
      width: 301,
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: burgundy, width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.black, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.beVietnamPro(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }
}