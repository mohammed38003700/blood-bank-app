class BloodRequest {
  int? id;
  String patientName;
  String bloodType;
  String hospital;
  String city;
  int unitsNeeded;
  int unitsReceived;
  String contactPhone;
  DateTime requestDate;
  bool isUrgent;
  String status;

  BloodRequest({
    this.id,
    required this.patientName,
    required this.bloodType,
    required this.hospital,
    required this.city,
    required this.unitsNeeded,
    this.unitsReceived = 0,
    required this.contactPhone,
    required this.requestDate,
    this.isUrgent = false,
    this.status = 'معلق',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patientName': patientName,
      'bloodType': bloodType,
      'hospital': hospital,
      'city': city,
      'unitsNeeded': unitsNeeded,
      'unitsReceived': unitsReceived,
      'contactPhone': contactPhone,
      'requestDate': requestDate.millisecondsSinceEpoch,
      'isUrgent': isUrgent ? 1 : 0,
      'status': status,
    };
  }

  factory BloodRequest.fromMap(Map<String, dynamic> map) {
    return BloodRequest(
      id: map['id'],
      patientName: map['patientName'],
      bloodType: map['bloodType'],
      hospital: map['hospital'],
      city: map['city'],
      unitsNeeded: map['unitsNeeded'],
      unitsReceived: map['unitsReceived'],
      contactPhone: map['contactPhone'],
      requestDate: DateTime.fromMillisecondsSinceEpoch(map['requestDate']),
      isUrgent: map['isUrgent'] == 1,
      status: map['status'],
    );
  }
}