import 'package:equatable/equatable.dart';

class MinAppVersionResponseModel extends Equatable {
  final String iosRecommendedMinVersion;
  final String iosRequiredMinVersion;
  final String androidRecommendedMinVersion;
  final String androidRequiredMinVersion;
  const MinAppVersionResponseModel({
    required this.iosRecommendedMinVersion,
    required this.iosRequiredMinVersion,
    required this.androidRecommendedMinVersion,
    required this.androidRequiredMinVersion,
  });

  MinAppVersionResponseModel copyWith({
    String? iosRecommendedMinVersion,
    String? iosRequiredMinVersion,
    String? androidRecommendedMinVersion,
    String? androidRequiredMinVersion,
  }) {
    return MinAppVersionResponseModel(
      iosRecommendedMinVersion:
          iosRecommendedMinVersion ?? this.iosRecommendedMinVersion,
      iosRequiredMinVersion:
          iosRequiredMinVersion ?? this.iosRequiredMinVersion,
      androidRecommendedMinVersion:
          androidRecommendedMinVersion ?? this.androidRecommendedMinVersion,
      androidRequiredMinVersion:
          androidRequiredMinVersion ?? this.androidRequiredMinVersion,
    );
  }

  Map<String, dynamic> toJson() => {
        'iosRecommendedMinVersion': iosRecommendedMinVersion,
        'iosRequiredMinVersion': iosRequiredMinVersion,
        'androidRecommendedMinVersion': androidRecommendedMinVersion,
        'androidRequiredMinVersion': androidRequiredMinVersion
      };

  factory MinAppVersionResponseModel.fromJson(Map<String, dynamic> json) {
    return MinAppVersionResponseModel(
      iosRecommendedMinVersion: json['iosRecommendedMinVersion'] ?? '',
      iosRequiredMinVersion: json['iosRequiredMinVersion'] ?? '',
      androidRecommendedMinVersion: json['androidRecommendedMinVersion'] ?? '',
      androidRequiredMinVersion: json['androidRequiredMinVersion'] ?? '',
    );
  }

  @override
  List<Object?> get props => [
        iosRecommendedMinVersion,
        iosRequiredMinVersion,
        androidRecommendedMinVersion,
        androidRequiredMinVersion
      ];

  @override
  bool get stringify => true;
}
