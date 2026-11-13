class Donor {
  int? id;
  String name;
  String bloodType;
  String phone;
  String city;
  DateTime lastDonation;
  bool isAvailable;

  Donor({
    this.id,
    required this.name,
    required this.bloodType,
    required this.phone,
    required this.city,
    required this.lastDonation,
    this.isAvailable = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'bloodType': bloodType,
      'phone': phone,
      'city': city,
      'lastDonation': lastDonation.millisecondsSinceEpoch,
      'isAvailable': isAvailable ? 1 : 0,
    };
  }

  factory Donor.fromMap(Map<String, dynamic> map) {
    return Donor(
      id: map['id'],
      name: map['name'],
      bloodType: map['bloodType'],
      phone: map['phone'],
      city: map['city'],
      lastDonation: DateTime.fromMillisecondsSinceEpoch(map['lastDonation']),
      isAvailable: map['isAvailable'] == 1,
    );
  }
}