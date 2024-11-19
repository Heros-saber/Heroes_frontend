import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

const Color burgundy = Color(0xFF570514);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            // 상단 바
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
              height: 1,
            ),
            // 나머지 콘텐츠
            Expanded(
              child: Container(
                color: Colors.grey[200],
                child: const Center(
                  child: Text("웹 페이지 내용"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}