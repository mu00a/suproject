
import 'package:flutter/material.dart';
import 'reports_page.dart'; // ✅ استيراد صفحة التقارير من الملف الجديد

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(color: const Color.fromARGB(255, 255, 255, 255)),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper:
                  CurveClipper(), // ✅ لا نضع const هنا لأنه يحتوي على override
              child: Container(
                height: MediaQuery.of(context).size.height * 0.6,
                color: const Color.fromARGB(255, 97, 3, 160),
              ),
            ),
          ),
          Column(
            children: [
              const Spacer(),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.description, color: Colors.white, size: 60),
                  SizedBox(width: 12),
                  Text(
                    'شواهد',
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'إدارة وتنظيم التقارير بسهولة مع إمكانية إدخال البيانات، إضافة الصور، وتخصيص الأهداف.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18, color: Color.fromARGB(255, 255, 255, 255)),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const ReportsPage()), // ✅ الانتقال إلى صفحة التقارير
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  'إنشاء تقرير جديد',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              const Spacer(),

              // ✅ تحسين عرض المعلومات الشخصية أسفل الصفحة
              const Column(
                children: [
                  Divider(
                      color: Colors.white70,
                      thickness: 1,
                      indent: 40,
                      endIndent: 40),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person,
                          color: Color.fromARGB(255, 17, 16, 16), size: 20),
                      SizedBox(width: 8),
                      Text(
                        'صالح القرني',
                        style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 15, 15, 15)),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.email,
                          color: Color.fromARGB(255, 15, 15, 15), size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Salehalqarni44@gmail.com',
                        style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 17, 17, 17)),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ✅ تعريف CurveClipper بدون const لأنه يحتوي على override
class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
