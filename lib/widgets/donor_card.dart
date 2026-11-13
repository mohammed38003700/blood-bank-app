import 'package:flutter/material.dart';
import '../models/donor.dart';

class DonorCard extends StatelessWidget {
  final Donor donor;
  final VoidCallback onDelete;
  final VoidCallback? onEdit;
  final VoidCallback? onCall;

  const DonorCard({
    Key? key,
    required this.donor,
    required this.onDelete,
    this.onEdit,
    this.onCall,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الصف العلوي: الاسم وفصيلة الدم
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    donor.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(243, 220, 8, 8),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getBloodTypeColor(donor.bloodType),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    donor.bloodType,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 12),
            
            // معلومات الاتصال
            _buildInfoRow(Icons.phone, donor.phone),
            SizedBox(height: 8),
            _buildInfoRow(Icons.location_city, donor.city),
            SizedBox(height: 8),
            _buildInfoRow(
              Icons.calendar_today,
              'آخر تبرع: ${_formatDate(donor.lastDonation)}',
            ),
            
            SizedBox(height: 12),
            
            // حالة المتبرع والأزرار
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // حالة المتبرع
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: donor.isAvailable ? Colors.green[100] : Colors.red[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: donor.isAvailable ? Colors.green : Color.fromARGB(243, 220, 8, 8),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        donor.isAvailable ? Icons.check_circle : Icons.cancel,
                        size: 16,
                        color: donor.isAvailable ? Colors.green :Color.fromARGB(243, 220, 8, 8),
                      ),
                      SizedBox(width: 4),
                      Text(
                        donor.isAvailable ? 'متاح للتبرع' : 'غير متاح',
                        style: TextStyle(
                          fontSize: 12,
                          color: donor.isAvailable ? Colors.green : Color.fromARGB(243, 220, 8, 8),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // أزرار الإجراءات
                Row(
                  children: [
                    if (onCall != null)
                      IconButton(
                        icon: Icon(Icons.phone, color: Colors.green),
                        onPressed: onCall,
                        tooltip: 'اتصال',
                      ),
                    if (onEdit != null)
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: onEdit,
                        tooltip: 'تعديل',
                      ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Color.fromARGB(243, 220, 8, 8)),
                      onPressed: onDelete,
                      tooltip: 'حذف',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // دالة لبناء صف معلومات
  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // دالة لتنسيق التاريخ
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // دالة لإرجاع لون فصيلة الدم
  Color _getBloodTypeColor(String bloodType) {
    switch (bloodType) {
      case 'A+':
        return Colors.red[800]!;
      case 'A-':
        return Colors.red[600]!;
      case 'B+':
        return Colors.blue[800]!;
      case 'B-':
        return Colors.blue[600]!;
      case 'AB+':
        return Colors.purple[800]!;
      case 'AB-':
        return Colors.purple[600]!;
      case 'O+':
        return Colors.green[800]!;
      case 'O-':
        return Colors.green[600]!;
      default:
        return Colors.grey;
    }
  }
}