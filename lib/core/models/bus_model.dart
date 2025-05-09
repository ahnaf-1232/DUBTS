class BusModel {
  final String id;
  final String name;
  final String route;
  final String company;
  final String type;
  final double fare;
  final String? imageUrl;

  BusModel({
    required this.id,
    required this.name,
    required this.route,
    required this.company,
    required this.type,
    required this.fare,
    this.imageUrl,
  });

  factory BusModel.fromMap(Map<String, dynamic> data, String id) {
    return BusModel(
      id: id,
      name: data['name'] ?? '',
      route: data['route'] ?? '',
      company: data['company'] ?? '',
      type: data['type'] ?? '',
      fare: (data['fare'] ?? 0.0).toDouble(),
      imageUrl: data['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'route': route,
      'company': company,
      'type': type,
      'fare': fare,
      'imageUrl': imageUrl,
    };
  }

  BusModel copyWith({
    String? id,
    String? name,
    String? route,
    String? company,
    String? type,
    double? fare,
    String? imageUrl,
  }) {
    return BusModel(
      id: id ?? this.id,
      name: name ?? this.name,
      route: route ?? this.route,
      company: company ?? this.company,
      type: type ?? this.type,
      fare: fare ?? this.fare,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
