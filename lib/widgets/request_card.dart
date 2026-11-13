import 'package:flutter/material.dart';
import '../models/blood_request.dart';

class RequestCard extends StatelessWidget {
  final BloodRequest request;
  final VoidCallback onUpdate;
  final VoidCallback onDelete;
  final VoidCallback? onContact;

  const RequestCard({
    Key? key,
    required this.request,
    required this.onUpdate,
    required this.onDelete,
    this.onContact,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      color: request.isUrgent ? Colors.red[50] : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // العنوان والحالة
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.patientName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: request.isUrgent ?Color.fromARGB(243, 220, 8, 8): Colors.blue[800],
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        request.hospital,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(request.status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    request.status,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 12),
            
            // فصيلة الدم والمعلومات
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red[300]!),
                  ),
                  child: Text(
                    '${request.bloodType} - ${request.unitsNeeded} وحدات',
                    style: TextStyle(
                      color: Color.fromARGB(243, 220, 8, 8),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.location_on, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text(
                  request.city,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
            
            SizedBox(height: 12),
            
            // معلومات الاتصال والتاريخ
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(Icons.phone, request.contactPhone),
                ),
                Expanded(
                  child: _buildInfoItem(
                    Icons.calendar_today,
                    '${_formatDate(request.requestDate)}',
                  ),
                ),
              ],
            ),
            
            // شريط التقدم
            SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'تقدم التبرع',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${request.unitsReceived} / ${request.unitsNeeded}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                LinearProgressIndicator(
                  value: request.unitsReceived / request.unitsNeeded,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    request.unitsReceived >= request.unitsNeeded 
                        ? Colors.green 
                        : Colors.orange,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ],
            ),
            
            // أزرار التحكم
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (request.isUrgent)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color:Color.fromARGB(124, 244, 67, 54),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.warning, size: 14, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          'عاجل',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                Spacer(),
                if (onContact != null)
                  IconButton(
                    icon: Icon(Icons.phone, color: Colors.green),
                    onPressed: onContact,
                    tooltip: 'اتصال',
                  ),
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: onUpdate,
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
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'مكتمل':
        return Colors.green;
      case 'قيد التجهيز':
        return Colors.orange;
      case 'عاجل':
        return Color.fromARGB(243, 220, 8, 8);
      case 'معلق':
      default:
        return Colors.grey;
    }
  }
}