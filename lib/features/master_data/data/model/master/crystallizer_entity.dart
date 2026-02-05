class CrystallizerEntity {
  final String id;
  final String name;

  CrystallizerEntity({required this.id, required this.name});

  factory CrystallizerEntity.fromMap(Map<String, dynamic> map) {
    return CrystallizerEntity(id: map['id'], name: map['name']);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }
}
