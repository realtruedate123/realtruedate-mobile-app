class DreamDateResponse {
  final bool success;
  final String message;
  final DreamDateData data;

  DreamDateResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory DreamDateResponse.fromJson(Map<String, dynamic> json) {
    return DreamDateResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: DreamDateData.fromJson(json['data'] ?? {}),
    );
  }
}

class DreamDateData {
  final List<DreamDateItem> catalog;
  final int total;
  final int selectCountRequired;

  DreamDateData({
    required this.catalog,
    required this.total,
    required this.selectCountRequired,
  });

  factory DreamDateData.fromJson(Map<String, dynamic> json) {
    return DreamDateData(
      catalog: (json['catalog'] as List? ?? [])
          .map((e) => DreamDateItem.fromJson(e))
          .toList(),
      total: json['total'] ?? 0,
      selectCountRequired: json['select_count_required'] ?? 0,
    );
  }
}
class DreamDateItem {
  final String id;
  final String name;
  final String gender;
  final String? imageUrl;
  // final DreamDateAttributes attributes;

  DreamDateItem({
    required this.id,
    required this.name,
    required this.gender,
    required this.imageUrl,
    // required this.attributes,
  });

  factory DreamDateItem.fromJson(Map<String, dynamic> json) {
    return DreamDateItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      gender: json['gender'] ?? '',
      imageUrl: json['image_url'],
      // attributes: DreamDateAttributes.fromJson(json['attributes'] ?? {}),
    );
  }
}

class DreamDateAttributes {
  final String hairLength;
  final String hairColor;
  final String eyeColor;
  final String eyeShape;
  final String tattoos;
  final String style;
  final String facialHair;

  DreamDateAttributes({
    required this.hairLength,
    required this.hairColor,
    required this.eyeColor,
    required this.eyeShape,
    required this.tattoos,
    required this.style,
    required this.facialHair,
  });

  factory DreamDateAttributes.fromJson(Map<String, dynamic> json) {
    return DreamDateAttributes(
      hairLength: json['hair_length'] ?? '',
      hairColor: json['hair_color'] ?? '',
      eyeColor: json['eye_color'] ?? '',
      eyeShape: json['eye_shape'] ?? '',
      tattoos: json['tattoos'] ?? '',
      style: json['style'] ?? '',
      facialHair: json['facial_hair'] ?? '',
    );
  }
}