import 'package:flutter/material.dart';
import 'donor_list_screen.dart';
import 'blood_requests_screen.dart';
import 'add_donor_screen.dart';
import 'add_request_screen.dart';
import 'analytics_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <_HomeItem>[
      _HomeItem('المتبرعون', 'عرض وإدارة بيانات المتبرعين', Icons.people_alt_outlined,
          const Color(0xFF1565C0),
          () => Navigator.push(context, MaterialPageRoute(builder: (_) => DonorListScreen()))),
      _HomeItem('طلبات الدم', 'متابعة الطلبات وحالاتها', Icons.bloodtype_outlined,
          const Color(0xFF00897B),
          () => Navigator.push(context, MaterialPageRoute(builder: (_) => BloodRequestsScreen()))),
      _HomeItem('إضافة متبرع', 'تسجيل متبرع جديد', Icons.person_add_alt_1,
          const Color(0xFFEF6C00),
          () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddDonorScreen()))),
      _HomeItem('طلب دم جديد', 'تسجيل احتياج لمريض أو مستشفى', Icons.add_circle_outline,
          const Color(0xFF6A1B9A),
          () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddRequestScreen()))),
      _HomeItem('التحليلات والتقارير', 'مؤشرات المتبرعين والطلبات', Icons.analytics_outlined,
          const Color(0xFFB71C1C),
          () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AnalyticsScreen()))),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('نظام إدارة بنك الدم',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFB71C1C), Color(0xFFE53935)],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.health_and_safety_outlined, color: Colors.white, size: 38),
                  SizedBox(height: 12),
                  Text('معاً لإنقاذ الحياة', style: TextStyle(
                    color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold)),
                  SizedBox(height: 6),
                  Text('إدارة بيانات المتبرعين وطلبات الدم من مكان واحد',
                    style: TextStyle(color: Colors.white, fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(height: 18),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.12,
              ),
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: item.onTap,
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: item.color.withOpacity(.12),
                            child: Icon(item.icon, color: item.color, size: 27),
                          ),
                          const SizedBox(height: 12),
                          Text(item.title, style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 5),
                          Text(item.subtitle, style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 11)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            const Text(
              'تنبيه: بيانات التطبيق إدارية، ويجب التحقق من فصائل الدم والتوافق والفحوصات وفق إجراءات بنك الدم المعتمدة.',
              style: TextStyle(color: Colors.black54, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _HomeItem(this.title, this.subtitle, this.icon, this.color, this.onTap);
}
