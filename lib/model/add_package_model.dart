class PackageNameModel {
  String? id; // Document ID
  String? packageName;

  PackageNameModel({
    this.id,
    this.packageName,
  });

  factory PackageNameModel.fromMap(String? id, Map<String, dynamic> map) {
    return PackageNameModel(
      id: id,
      packageName: map['packageName'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'packageName': packageName,
    };
  }
}
