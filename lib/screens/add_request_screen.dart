import 'package:flutter/material.dart';
import '../models/blood_request.dart';
import '../database/database_helper.dart';

class AddRequestScreen extends StatefulWidget {
  @override
  _AddRequestScreenState createState() => _AddRequestScreenState();
}

class _AddRequestScreenState extends State<AddRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _patientNameController = TextEditingController();
  final _hospitalController = TextEditingController();
  final _cityController = TextEditingController();
  final _contactPhoneController = TextEditingController();
  final _unitsController = TextEditingController(text: '1');
  
  String _selectedBloodType = 'A+';
  bool _isUrgent = false;
  
  final List<String> bloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('طلب دم جديد',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 30),),
        backgroundColor: Color.fromARGB(243, 220, 8, 8),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _patientNameController,
                  decoration: InputDecoration(
                    labelText: 'اسم المريض',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال اسم المريض';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                
                DropdownButtonFormField<String>(
                  value: _selectedBloodType,
                  decoration: InputDecoration(
                    labelText: 'فصيلة الدم المطلوبة',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.bloodtype),
                  ),
                  items: bloodTypes.map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedBloodType = newValue!;
                    });
                  },
                ),
                SizedBox(height: 16),
                
                TextFormField(
                  controller: _hospitalController,
                  decoration: InputDecoration(
                    labelText: 'اسم المستشفى',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.local_hospital),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال اسم المستشفى';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                
                TextFormField(
                  controller: _cityController,
                  decoration: InputDecoration(
                    labelText: 'المدينة',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_city),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال المدينة';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                
                TextFormField(
                  controller: _unitsController,
                  decoration: InputDecoration(
                    labelText: 'عدد الوحدات المطلوبة',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.bloodtype),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال عدد الوحدات';
                    }
                    if (int.tryParse(value) == null || int.parse(value) <= 0) {
                      return 'يرجى إدخال عدد صحيح موجب';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                
                TextFormField(
                  controller: _contactPhoneController,
                  decoration: InputDecoration(
                    labelText: 'رقم التواصل',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال رقم التواصل';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                
                SwitchListTile(
                  title: Text('طلب عاجل', style: TextStyle(color:Color.fromARGB(249, 248, 247, 247))),
                  subtitle: Text('سيظهر هذا الطلب كعاجل في القائمة'),
                  value: _isUrgent,
                  onChanged: (bool value) {
                    setState(() {
                      _isUrgent = value;
                    });
                  },
                  secondary: Icon(Icons.warning, color: _isUrgent ? Color.fromARGB(124, 244, 67, 54) : Colors.grey),
                ),
                
                SizedBox(height: 24),
                
                ElevatedButton(
                  onPressed: _saveRequest,
                  child: Text('حفظ الطلب', style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(243, 220, 8, 8),
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveRequest() async {
    if (_formKey.currentState!.validate()) {
      final request = BloodRequest(
        patientName: _patientNameController.text,
        bloodType: _selectedBloodType,
        hospital: _hospitalController.text,
        city: _cityController.text,
        unitsNeeded: int.parse(_unitsController.text),
        contactPhone: _contactPhoneController.text,
        requestDate: DateTime.now(),
        isUrgent: _isUrgent,
        status: 'معلق',
      );

      await DatabaseHelper().insertBloodRequest(request);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم حفظ الطلب بنجاح')),
      );
      
      Navigator.pop(context);
    }
  }
}