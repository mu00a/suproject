



import 'package:flutter/material.dart';
import 'template_page.dart'; // استيراد صفحة TemplatePage

class BackgroundSelectionPage extends StatelessWidget {
  const BackgroundSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    // قائمة بمسارات صور القوالب
    final List<String> templateImages = [
      'assets/image/templateframe.png',
      'assets/image/templateframe1.png',
      'assets/image/templateframe2.png',
      'assets/image/templateframe3.png',
      'assets/image/templateframe4.png',
      'assets/image/templateframe5.png',
      'assets/image/templateframe6.png',
      'assets/image/templateframe7.png',
      'assets/image/templateframe8.png',
    ];

    // نصوص القوالب (يمكنك تعديلها حسب المطلوب)
    final List<String> templateTitles = [
      'القالب رقم 9',
      'القالب رقم 7',
      'القالب رقم 8',
      'القالب رقم 5',
      'القالب رقم 6',
      'القالب رقم 3',
      'القالب رقم 4',
      'القالب رقم 1',
      'القالب رقم 2',
    ];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // شريط العنوان (SliverAppBar)
          SliverAppBar(
            title: const Text(
              'اختر القالب المناسب',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.deepPurple, // لون بنفسجي داكن
            expandedHeight: 200, // ارتفاع الشريط عند التوسيع
            floating: true, // يظهر عند التمرير لأعلى
            pinned: true, // يبقى ثابتًا عند التمرير
            flexibleSpace: FlexibleSpaceBar(
              background: ClipPath(
                clipper: CurvedClipper(), // شكل منحني أسفل الشريط
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF6A1B9A), // لون بنفسجي داكن
                        Color(0xFF4527A0), // لون بنفسجي أزرق
                      ],
                    ),
                  ),
                ),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back,
                  color: Colors.white), // أيقونة السهم تشير إلى اليسار
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),

          // محتوى الصفحة (SliverGrid)
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8, // تغيير نسبة العرض إلى الارتفاع
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                // عكس ترتيب العناصر لتبدأ من اليمين
                final reversedIndex = templateImages.length - 1 - index;
                return Card(
                  color: Colors.white
                      .withAlpha(229), // لون أبيض شفاف (90% opacity)
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: InkWell(
                    onTap: () {
                      // فتح صفحة TemplatePage مع تمرير مسار الصورة
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TemplatePage(
                            imagePath: templateImages[reversedIndex],
                          ),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Image.asset(
                                templateImages[reversedIndex],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          child: Directionality(
                            textDirection: TextDirection
                                .rtl, // تحديد اتجاه النص من اليمين لليسار
                            child: Text(
                              templateTitles[
                                  reversedIndex], // استخدام النص من القائمة
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple, // لون بنفسجي داكن
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              childCount: templateImages.length,
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Clipper لإنشاء شكل منحني
class CurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 50); // بداية المنحنى
    path.quadraticBezierTo(
      size.width / 2, size.height, // نقطة التحكم في المنحنى
      size.width, size.height - 50, // نهاية المنحنى
    );
    path.lineTo(size.width, 0); // العودة إلى الأعلى
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}


