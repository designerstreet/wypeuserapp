class SavedLocation {
  String? id;
  String address;
  double latitude;
  double longitude;

  SavedLocation(
      {this.id,
      required this.address,
      required this.latitude,
      required this.longitude});

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory SavedLocation.fromMap(Map<String, dynamic> map) {
    return SavedLocation(
      address: map['address'],
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }
}
