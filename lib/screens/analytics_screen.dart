import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/donor.dart';
import '../models/blood_request.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final DatabaseHelper _database = DatabaseHelper();
  late Future<_AnalyticsData> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = _loadData();
  }

  Future<_AnalyticsData> _loadData() async {
    final results = await Future.wait([
      _database.getDonors(),
      _database.getBloodRequests(),
    ]);
    return _AnalyticsData(
      donors: results[0] as List<Donor>,
      requests: results[1] as List<BloodRequest>,
    );
  }

  void _refresh() {
    setState(() => _dataFuture = _loadData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('التحليلات والتقارير'),
        actions: [
          IconButton(
            tooltip: 'تحديث البيانات',
            onPressed: _refresh,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder<_AnalyticsData>(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('تعذر تحميل البيانات: ${snapshot.error}'));
          }
          final data = snapshot.data!;
          final totalDonors = data.donors.length;
          final availableDonors = data.donors.where((d) => d.isAvailable).length;
          final totalRequests = data.requests.length;
          final urgentRequests = data.requests.where((r) => r.isUrgent).length;
          final pendingRequests = data.requests.where((r) =>
              r.status == 'معلق' || r.status == 'قيد المعالجة').length;
          final fulfilledUnits = data.requests.fold<int>(
              0, (sum, request) => sum + request.unitsReceived);
          final requestedUnits = data.requests.fold<int>(
              0, (sum, request) => sum + request.unitsNeeded);

          final types = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
          final counts = <String, int>{
            for (final type in types)
              type: data.donors.where((d) => d.bloodType == type).length,
          };
          final maxCount = counts.values.fold<int>(0, (a, b) => a > b ? a : b);

          return RefreshIndicator(
            onRefresh: () async => _refresh(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text('ملخص بنك الدم', style: TextStyle(
                  fontSize: 21, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.65,
                  children: [
                    _MetricCard(title: 'إجمالي المتبرعين', value: '$totalDonors',
                      icon: Icons.people_alt_outlined, color: const Color(0xFF1565C0)),
                    _MetricCard(title: 'المتاحون للتواصل', value: '$availableDonors',
                      icon: Icons.volunteer_activism_outlined, color: const Color(0xFF00897B)),
                    _MetricCard(title: 'إجمالي الطلبات', value: '$totalRequests',
                      icon: Icons.assignment_outlined, color: const Color(0xFF6A1B9A)),
                    _MetricCard(title: 'الطلبات العاجلة', value: '$urgentRequests',
                      icon: Icons.priority_high, color: const Color(0xFFC62828)),
                  ],
                ),
                const SizedBox(height: 22),
                _sectionTitle('المتبرعون حسب فصيلة الدم'),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: types.map((type) {
                        final count = counts[type] ?? 0;
                        final progress = maxCount == 0 ? 0.0 : count / maxCount;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 7),
                          child: Row(
                            children: [
                              SizedBox(width: 42, child: Text(type,
                                style: const TextStyle(fontWeight: FontWeight.bold))),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: LinearProgressIndicator(
                                    value: progress,
                                    minHeight: 11,
                                    backgroundColor: Colors.grey.shade200,
                                    color: const Color(0xFFB71C1C),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              SizedBox(width: 25, child: Text('$count',
                                textAlign: TextAlign.end)),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                _sectionTitle('مؤشرات طلبات الدم'),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _InfoRow(label: 'طلبات معلقة أو قيد المعالجة', value: '$pendingRequests'),
                        const Divider(),
                        _InfoRow(label: 'الوحدات المطلوبة', value: '$requestedUnits'),
                        const Divider(),
                        _InfoRow(label: 'الوحدات المسجلة كمستلمة', value: '$fulfilledUnits'),
                        const Divider(),
                        _InfoRow(
                          label: 'نسبة التغطية المسجلة',
                          value: requestedUnits == 0
                              ? '—'
                              : '${(fulfilledUnits * 100 / requestedUnits).clamp(0, 100).toStringAsFixed(1)}%',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'هذه المؤشرات محسوبة من السجلات المدخلة في قاعدة البيانات المحلية. '
                  'لا تمثل مخزوناً فعلياً أو حكماً طبياً على صلاحية وحدات الدم.',
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(title, style: const TextStyle(
      fontSize: 17, fontWeight: FontWeight.bold)),
  );
}

class _AnalyticsData {
  final List<Donor> donors;
  final List<BloodRequest> requests;
  const _AnalyticsData({required this.donors, required this.requests});
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  const _MetricCard({required this.title, required this.value,
    required this.icon, required this.color});

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(icon, color: color, size: 27),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold)),
                Text(title, style: const TextStyle(fontSize: 11),
                  maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 7),
    child: Row(
      children: [
        Expanded(child: Text(label)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    ),
  );
}
