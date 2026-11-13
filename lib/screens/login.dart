import 'package:flutter/material.dart';
import 'package:flutter_application_7/screens/home_screen.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // خلفية متدرجة للألوان
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight, // بداية التدرج من الأعلى يمين
            end: Alignment.bottomLeft, // نهاية التدرج من الأسفل يسار
            colors: [
              Color.fromARGB(255, 179, 8, 8)!, // لون أزرق غامق
              const Color.fromARGB(255, 240, 239, 241)!, // لون بنفسجي
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0), // هامش حول المحتوى
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // توسيط المحتوى عمودياً
              children: [
                // أيقونة التطبيق
                Icon(
                  Icons.monitor_heart, // نوع الأيقونة
                  size: 100, // حجم الأيقونة
                  color: Colors.white, // لون الأيقونة
                ),
                SizedBox(height: 20), // مسافة فارغة بين العناصر

                // نص الترحيب الرئيسي
                Text(
                  'مرحباً بك', // نص الترحيب
                  style: TextStyle(
                    fontSize: 32, // حجم الخط كبير
                    fontWeight: FontWeight.bold, // خط عريض
                    color: Colors.white, // لون أبيض
                  ),
                ),
                SizedBox(height: 10), // مسافة فارغة بين النصوص

                // نص ترحيبي ثانوي
                Text(
                  'في تطبيقنا الرائع', // وصف التطبيق
                  style: TextStyle(
                    fontSize: 18, // حجم خط متوسط
                    color: Colors.white70, // لون أبيض شفاف
                  ),
                  textAlign: TextAlign.center, // توسيط النص
                ),
                SizedBox(height: 50), // مسافة كبيرة قبل الزر

                // زر الدخول الرئيسي
                Container(
                  width: double.infinity, // عرض كامل للشاشة
                  height: 60, // ارتفاع مناسب للزر
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    },
                    child: Text(
                      'دخول للتطبيق', // نص الزر
                      style: TextStyle(
                        fontSize: 18, // حجم خط الزر
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // خط عريض
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // خلفية بيضاء للزر
                      foregroundColor: Color.fromARGB(158, 237, 50, 8), // لون النص أزرق
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // زوايا دائرية
                      ),
                      elevation: 5, // ظل للزر
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
