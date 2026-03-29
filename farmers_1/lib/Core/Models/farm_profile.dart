class FarmProfile {
  final String? id;
  final String userId;
  final String farmName;
  final String location;
  final String size;
  final List<String> crops;
  final List<String> livestock;
  final String ownerName;
  final String email;
  final String phone;
  final DateTime createdAt;
  final DateTime updatedAt;

  FarmProfile({
    this.id,
    required this.userId,
    required this.farmName,
    required this.location,
    required this.size,
    required this.crops,
    required this.livestock,
    required this.ownerName,
    required this.email,
    required this.phone,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'farmName': farmName,
      'location': location,
      'size': size,
      'crops': crops,
      'livestock': livestock,
      'ownerName': ownerName,
      'email': email,
      'phone': phone,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory FarmProfile.fromMap(Map<String, dynamic> map, String documentId) {
    return FarmProfile(
      id: documentId,
      userId: map['userId'] ?? '',
      farmName: map['farmName'] ?? '',
      location: map['location'] ?? '',
      size: map['size'] ?? '',
      crops: List<String>.from(map['crops'] ?? []),
      livestock: List<String>.from(map['livestock'] ?? []),
      ownerName: map['ownerName'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      createdAt: DateTime.parse(
        map['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        map['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  FarmProfile copyWith({
    String? id,
    String? userId,
    String? farmName,
    String? location,
    String? size,
    List<String>? crops,
    List<String>? livestock,
    String? ownerName,
    String? email,
    String? phone,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FarmProfile(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      farmName: farmName ?? this.farmName,
      location: location ?? this.location,
      size: size ?? this.size,
      crops: crops ?? this.crops,
      livestock: livestock ?? this.livestock,
      ownerName: ownerName ?? this.ownerName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'FarmProfile(id: $id, userId: $userId, farmName: $farmName, location: $location, size: $size, crops: $crops, livestock: $livestock, ownerName: $ownerName, email: $email, phone: $phone, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FarmProfile &&
        other.id == id &&
        other.userId == userId &&
        other.farmName == farmName &&
        other.location == location &&
        other.size == size &&
        other.crops.toString() == crops.toString() &&
        other.livestock.toString() == livestock.toString() &&
        other.ownerName == ownerName &&
        other.email == email &&
        other.phone == phone &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        farmName.hashCode ^
        location.hashCode ^
        size.hashCode ^
        crops.hashCode ^
        livestock.hashCode ^
        ownerName.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
