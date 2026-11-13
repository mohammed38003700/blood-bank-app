import 'package:flutter/material.dart';
import '../models/donor.dart';
import '../database/database_helper.dart';
import '../widgets/donor_card.dart';

class DonorListScreen extends StatefulWidget {
  @override
  _DonorListScreenState createState() => _DonorListScreenState();
}

class _DonorListScreenState extends State<DonorListScreen> {
  List<Donor> donors = [];
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadDonors();
  }

  Future<void> _loadDonors() async {
    final loadedDonors = await _databaseHelper.getDonors();
    setState(() {
      donors = loadedDonors;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('قائمة المتبرعين',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 30),),
        backgroundColor: Color.fromARGB(243, 220, 8, 8),
      ),
      body: donors.isEmpty
          ? Center(
              child: Text(
                'لا يوجد متبرعين مسجلين',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: donors.length,
              itemBuilder: (context, index) {
                return DonorCard(
                  donor: donors[index],
                  onDelete: () => _deleteDonor(donors[index].id!),
                );
              },
            ),
    );
  }

  Future<void> _deleteDonor(int id) async {
    await _databaseHelper.deleteDonor(id);
    _loadDonors();
  }
}