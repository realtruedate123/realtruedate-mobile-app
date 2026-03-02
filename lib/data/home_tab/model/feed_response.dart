import 'dart:convert';

/// Main response model
class FeedResponse {
  final bool success;
  final String message;
  final FeedData data;

  FeedResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory FeedResponse.fromJson(Map<String, dynamic> json) => FeedResponse(
    success: json['success'] ?? false,
    message: json['message'] ?? '',
    data: FeedData.fromJson(json['data'] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'data': data.toJson(),
  };
}

/// Data model containing candidates
class FeedData {
  final List<Candidate> candidates;
  final int total;

  FeedData({
    required this.candidates,
    required this.total,
  });

  factory FeedData.fromJson(Map<String, dynamic> json) => FeedData(
    candidates: json['candidates'] != null
        ? List<Candidate>.from(
        (json['candidates'] as List)
            .map((x) => Candidate.fromJson(x)))
        : [],
    total: json['total'] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'candidates': candidates.map((x) => x.toJson()).toList(),
    'total': total,
  };
}

/// Candidate model
class Candidate {
  final String userId;
  final String firstName;
  final int age;
  final String? city;
  final String? state;
  final String? photoUrl;
  final bool isVerified;

  Candidate({
    required this.userId,
    required this.firstName,
    required this.age,
    this.city,
    this.state,
    this.photoUrl,
    required this.isVerified,
  });

  factory Candidate.fromJson(Map<String, dynamic> json) => Candidate(
    userId: json['user_id'] ?? '',
    firstName: json['first_name'] ?? '',
    age: json['age'] ?? 0,
    city: json['city'],
    state: json['state'],
    photoUrl: json['photo_url'],
    isVerified: json['is_verified'] ?? false,
  );

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'first_name': firstName,
    'age': age,
    'city': city,
    'state': state,
    'photo_url': photoUrl,
    'is_verified': isVerified,
  };
}