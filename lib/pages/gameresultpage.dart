import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';

const Color burgundy = Color(0xFF570514);

class GameResultPage extends StatefulWidget {
  const GameResultPage({super.key});

  @override
  _GameResultPageState createState() => _GameResultPageState();
}

class _GameResultPageState extends State<GameResultPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // 더미 데이터: 이벤트 목록
  final Map<DateTime, String> _events = {
    DateTime(2024, 11, 10): '키움 5:3 LG (승)',
    DateTime(2024, 11, 15): '키움 2:6 KIA (패)',
    DateTime(2024, 11, 20): '키움 7:8 삼성 (패)',
    DateTime(2024, 11, 25): '키움 4:2 SSG (승)',
  };

  String? _getEventForDay(DateTime day) {
    return _events[DateTime(day.year, day.month, day.day)];
  }

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
          // 구분선
          const Divider(
            color: burgundy,
            thickness: 1,
          ),
          // 달력
          Expanded(
            child: Center(
              child: Container(
                width: 800,
                height: 450,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: burgundy, width: 1),
                ),
                child: TableCalendar(
                  firstDay: DateTime.utc(2023, 1, 1),
                  lastDay: DateTime.utc(2024, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  calendarFormat: CalendarFormat.month,
                  rowHeight: 65,
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
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
                    cellMargin: const EdgeInsets.symmetric(vertical: 80, horizontal: 4), // 세로 간격 조정
                  ),
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) {
                      final event = _getEventForDay(day);
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${day.day}', // 날짜 표시
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          if (event != null) // 이벤트가 있는 경우
                            Text(
                              event,
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 12,
                                color: burgundy,
                              ),
                              textAlign: TextAlign.center,
                            ),
                        ],
                      );
                    },
                    todayBuilder: (context, day, focusedDay) {
                      final event = _getEventForDay(day);
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: burgundy,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              '${day.day}',
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          if (event != null)
                            Text(
                              event,
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 12,
                                color: burgundy,
                              ),
                              textAlign: TextAlign.center,
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}