import 'package:flutter/material.dart';
import '../models/blood_request.dart';
import '../database/database_helper.dart';
import '../widgets/request_card.dart';
import 'add_request_screen.dart';

class BloodRequestsScreen extends StatefulWidget {
  @override
  _BloodRequestsScreenState createState() => _BloodRequestsScreenState();
}

class _BloodRequestsScreenState extends State<BloodRequestsScreen> {
  List<BloodRequest> requests = [];
  List<BloodRequest> filteredRequests = [];
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // عوامل التصفية
  String _selectedFilter = 'الكل';
  final List<String> _filterOptions = [
    'الكل',
    'عاجل',
    'مكتمل',
    'معلق',
    'قيد التجهيز'
  ];

  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    final loadedRequests = await _databaseHelper.getBloodRequests();
    setState(() {
      requests = loadedRequests;
      _applyFilters();
    });
  }

  void _applyFilters() {
    setState(() {
      filteredRequests = requests.where((request) {
        final matchesSearch = _searchController.text.isEmpty ||
            request.patientName
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()) ||
            request.hospital
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()) ||
            request.bloodType.contains(_searchController.text);

        final matchesFilter = _selectedFilter == 'الكل' ||
            (_selectedFilter == 'عاجل' && request.isUrgent) ||
            (_selectedFilter == 'مكتمل' && request.status == 'مكتمل') ||
            (_selectedFilter == 'معلق' && request.status == 'معلق') ||
            (_selectedFilter == 'قيد التجهيز' &&
                request.status == 'قيد التجهيز');

        return matchesSearch && matchesFilter;
      }).toList();

      // ترتيب الطلبات: العاجلة أولاً ثم المعلقة
      filteredRequests.sort((a, b) {
        if (a.isUrgent && !b.isUrgent) return -1;
        if (!a.isUrgent && b.isUrgent) return 1;
        return b.requestDate.compareTo(a.requestDate);
      });
    });
  }

  Future<void> _deleteRequest(int id) async {
    bool? confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('تأكيد الحذف'),
          content: Text('هل أنت متأكد من حذف هذا الطلب؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('إلغاء'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('حذف', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
     
      await _databaseHelper.deletblood(id);
      _loadRequests();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم حذف الطلب بنجاح')),
      );
    }
  
}

  Future<void> _updateRequestStatus(
      BloodRequest request, String newStatus) async {
    final updatedRequest = BloodRequest(
      id: request.id,
      patientName: request.patientName,
      bloodType: request.bloodType,
      hospital: request.hospital,
      city: request.city,
      unitsNeeded: request.unitsNeeded,
      unitsReceived: request.unitsReceived,
      contactPhone: request.contactPhone,
      requestDate: request.requestDate,
      isUrgent: request.isUrgent,
      status: newStatus,
    );

    await _databaseHelper.updateBloodRequest(updatedRequest);
    _loadRequests();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم تحديث حالة الطلب إلى $newStatus')),
    );
  }

  Future<void> _updateUnitsReceived(BloodRequest request) async {
    final newUnits = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        TextEditingController unitsController =
            TextEditingController(text: request.unitsReceived.toString());

        return AlertDialog(
          title: Text('تحديث الوحدات المستلمة'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('الوحدات المطلوبة: ${request.unitsNeeded}'),
              SizedBox(height: 10),
              TextField(
                controller: unitsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'الوحدات المستلمة',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                final units =
                    int.tryParse(unitsController.text) ?? request.unitsReceived;
                Navigator.of(context).pop(units);
              },
              child: Text('حفظ'),
            ),
          ],
        );
      },
    );

    if (newUnits != null) {
      final updatedRequest = BloodRequest(
        id: request.id,
        patientName: request.patientName,
        bloodType: request.bloodType,
        hospital: request.hospital,
        city: request.city,
        unitsNeeded: request.unitsNeeded,
        unitsReceived: newUnits,
        contactPhone: request.contactPhone,
        requestDate: request.requestDate,
        isUrgent: request.isUrgent,
        status: newUnits >= request.unitsNeeded ? 'مكتمل' : request.status,
      );

      await _databaseHelper.updateBloodRequest(updatedRequest);
      _loadRequests();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم تحديث الوحدات المستلمة إلى $newUnits')),
      );
    }
  }

  void _showRequestActions(BloodRequest request) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'إجراءات الطلب',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),

              // تغيير الحالة
              ListTile(
                leading: Icon(Icons.update, color: Colors.blue),
                title: Text('تغيير الحالة'),
                trailing: DropdownButton<String>(
                  value: request.status,
                  onChanged: (String? newStatus) {
                    Navigator.pop(context);
                    if (newStatus != null) {
                      _updateRequestStatus(request, newStatus);
                    }
                  },
                  items: ['معلق', 'قيد التجهيز', 'مكتمل'].map((String status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                ),
              ),

              // تحديث الوحدات
              ListTile(
                leading: Icon(Icons.bloodtype, color:Color.fromARGB(243, 220, 8, 8)),
                title: Text('تحديث الوحدات المستلمة'),
                onTap: () {
                  Navigator.pop(context);
                  _updateUnitsReceived(request);
                },
              ),

              // وضع عاجل/عادي
              ListTile(
                leading: Icon(
                  request.isUrgent ? Icons.warning : Icons.check_circle,
                  color: request.isUrgent ? Color.fromARGB(243, 220, 8, 8) : Colors.green,
                ),
                title: Text(request.isUrgent ? 'إلغاء العاجل' : 'وضع عاجل'),
                onTap: () {
                  Navigator.pop(context);
                  final updatedRequest = BloodRequest(
                    id: request.id,
                    patientName: request.patientName,
                    bloodType: request.bloodType,
                    hospital: request.hospital,
                    city: request.city,
                    unitsNeeded: request.unitsNeeded,
                    unitsReceived: request.unitsReceived,
                    contactPhone: request.contactPhone,
                    requestDate: request.requestDate,
                    isUrgent: !request.isUrgent,
                    status: request.status,
                  );

                  _databaseHelper.updateBloodRequest(updatedRequest);
                  _loadRequests();
                },
              ),

              // حذف الطلب
              ListTile(
                leading: Icon(Icons.delete, color: Color.fromARGB(243, 220, 8, 8)),
                title: Text('حذف الطلب', style: TextStyle(color: Color.fromARGB(243, 220, 8, 8))),
                onTap: () {
                  Navigator.pop(context);
                  _deleteRequest(request.id!);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('طلبات الدم',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 30),),
        backgroundColor:Color.fromARGB(243, 220, 8, 8),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddRequestScreen()),
              );
              _loadRequests();
            },
            tooltip: 'إضافة طلب جديد',
          ),
        ],
      ),
      body: Column(
        children: [
          // شريط البحث والتصفية
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // شريط البحث
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'بحث في الطلبات',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _applyFilters();
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) => _applyFilters(),
                ),
                SizedBox(height: 12),

                // قائمة التصفية
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _filterOptions.map((filter) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: FilterChip(
                          label: Text(filter),
                          selected: _selectedFilter == filter,
                          onSelected: (selected) {
                            setState(() {
                              _selectedFilter = selected ? filter : 'الكل';
                              _applyFilters();
                            });
                          },
                          selectedColor:  Colors.red[100],
                          checkmarkColor:Color.fromARGB(243, 220, 8, 8),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // إحصائيات سريعة
          if (filteredRequests.isNotEmpty)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.grey[100],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                      'الكل', requests.length.toString(), Colors.blue),
                  _buildStatItem(
                      'عاجل',
                      requests.where((r) => r.isUrgent).length.toString(),
                     Color.fromARGB(243, 220, 8, 8)),
                  _buildStatItem(
                      'مكتمل',
                      requests
                          .where((r) => r.status == 'مكتمل')
                          .length
                          .toString(),
                      Colors.green),
                ],
              ),
            ),

          // قائمة الطلبات
          Expanded(
            child: filteredRequests.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.bloodtype, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          _searchController.text.isEmpty &&
                                  _selectedFilter == 'الكل'
                              ? 'لا توجد طلبات دم'
                              : 'لا توجد نتائج',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        if (_searchController.text.isEmpty &&
                            _selectedFilter == 'الكل')
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddRequestScreen()),
                              );
                            },
                            child: Text('إضافة أول طلب'),
                          ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadRequests,
                    child: ListView.builder(
                      itemCount: filteredRequests.length,
                      itemBuilder: (context, index) {
                        final request = filteredRequests[index];
                        return RequestCard(
                          request: request,
                          onUpdate: () => _showRequestActions(request),
                          onDelete: () => _deleteRequest(request.id!),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String title, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          title,
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}
