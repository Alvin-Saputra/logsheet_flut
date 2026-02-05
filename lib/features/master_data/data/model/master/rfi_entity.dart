class RfiEntity {
  final String id;
  final String name;

  RfiEntity({required this.id, required this.name});

  factory RfiEntity.fromMap(Map<String, dynamic> map) {
    return RfiEntity(id: map['id'], name: map['name']);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }
}
