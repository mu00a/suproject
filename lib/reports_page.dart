import 'package:flutter/material.dart';
import 'background_selection_page.dart'; // استيراد صفحة اختيار القالب

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ألوان مخصصة
    const Color appBarColor = Colors.deepPurple; // لون شريط العنوان
    final Color buttonColor = Colors.deepPurple.shade400; // لون الأزرار
    final Color shadowColor = Colors.deepPurple.shade700; // لون ظل الأزرار
    final Color dividerColor = Colors.deepPurple.shade300; // لون الخط الفاصل
    final Color textColor = Colors.deepPurple.shade900; // لون النص
    final Color backgroundColor = Colors.grey.shade200; // لون الخلفية الرمادي

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80), // ارتفاع شريط العنوان
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(30), // جعل الحواف السفلية منحنية
          ),
          child: AppBar(
            title: const Text(
              'الرئيسية',
              style: TextStyle(
                color: Colors.white, // لون النص الأبيض
                fontWeight: FontWeight.bold, // نص عريض
                fontSize: 24, // حجم النص
              ),
            ),
            centerTitle: true, // توسيط النص
            leading: IconButton(
              icon: const Icon(Icons.arrow_back,
                  color: Colors.white), // لون الأيقونة أبيض
              onPressed: () {
                Navigator.pop(context); // الرجوع إلى الصفحة السابقة
              },
            ),
            backgroundColor: appBarColor, // لون خلفية AppBar
            elevation: 10, // إضافة ظل لـ AppBar
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30), // جعل الحواف السفلية منحنية
              ),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: backgroundColor, // لون خلفية الصفحة
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // زر اختيار القالب
              _buildCustomButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BackgroundSelectionPage(),
                    ),
                  );
                },
                icon: Icons.assignment,
                label: 'اختر القالب المناسب',
                buttonColor: buttonColor,
                shadowColor: shadowColor,
              ),
              const SizedBox(height: 50),
              // إضافة نص زخرفي
              Text(
                'أنشئ تقاريرك بسهولة',
                style: TextStyle(
                  fontSize: 20,
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              // إضافة خط زخرفي
              Divider(
                color: dividerColor, // اللون يتم التحكم فيه ديناميكيًا
                thickness: 2,
                indent: 50,
                endIndent: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // دالة لبناء أزرار مخصصة
  Widget _buildCustomButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color buttonColor,
    required Color shadowColor,
  }) {
    return Container(
      width: 300, // زيادة عرض الزر
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25), // حواف مستديرة
        boxShadow: [
          BoxShadow(
            color: shadowColor
                .withAlpha(77), // استخدام withAlpha بدلاً من withOpacity
            blurRadius: 10, // قوة التموج
            offset: const Offset(0, 5), // اتجاه الظل
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 28, color: Colors.white), // زيادة حجم الأيقونة
        label: Text(
          label,
          style: const TextStyle(
              fontSize: 20, color: Colors.white), // زيادة حجم النص
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
              horizontal: 30, vertical: 20), // زيادة الحشو
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25), // حواف مستديرة
          ),
          backgroundColor: buttonColor, // لون الخلفية
          elevation: 0, // إزالة الظل الافتراضي
        ),
      ),
    );
  }
}